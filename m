Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3L3O4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:56:49 -0500
Received: from mail.wdtv.com ([66.118.69.84]:55166 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab3L3O4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:56:47 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [BUG BISECTED] Phenom microcode revision mis-applied
Date: Mon, 30 Dec 2013 09:56:44 -0500
Cc: linux-kernel@vger.kernel.org
References: <201312291224.03854.gheskett@wdtv.com> <201312292202.02236.gheskett@wdtv.com> <20131230123700.GS19878@titan.lakedaemon.net>
In-Reply-To: <20131230123700.GS19878@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201312300956.45168.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 December 2013, Jason Cooper wrote:
>On Sun, Dec 29, 2013 at 10:02:02PM -0500, Gene Heskett wrote:
>...
>
>> Finally done with the forward bisect:
>> 
>> gene@coyote:~/linux-stable$ dmesg|grep -A2 microcode
>> microcode: CPU0: patch_level=0x01000065
>> microcode: CPU0: new patch_level=0x01000083
>> microcode: CPU1: patch_level=0x01000065
>> microcode: CPU1: new patch_level=0x01000083
>> microcode: CPU2: patch_level=0x01000065
>> microcode: CPU2: new patch_level=0x01000083
>> microcode: CPU3: patch_level=0x01000065
>> microcode: CPU3: new patch_level=0x01000083
>> microcode: Microcode Update Driver: v2.00
>> <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>> 
>> gene@coyote:~/linux-stable$ git bisect good
>> 1a45c310b2102c58e37f84abba67fe21d5d6edcf is the first bad commit
>> commit 1a45c310b2102c58e37f84abba67fe21d5d6edcf
>> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Date:   Thu Mar 14 11:27:14 2013 -0700
>> 
>>     Linux 3.8.3
>> :
>> :100644 100644 20d53183508e8f49253ec7e5ede0a12b4556fc32
>> :8c49fc9b45a993a8e78cde4f9621b727b9121eac M	Makefile
>> 
>> The v3.8.3 Makefile?  Its just about the only thing that would be bad
>> every step from v3.8.3 to v3.8.2, and good all the way from v3.8.2 to
>> the last patch that made the v3.8.3 release.  Bisected twice, once in
>> each direction.
>
>When it works, which CONFIG_MICROCODE* options are set?  And unset when
>it fails?
>
That is not being intentionally changed. But this line I see very early in 
the build trace:

scripts/kconfig/conf --silentoldconfig Kconfig

seems to be undoing any changes I make with a make xconfig.  I must have 
turned off the intel video and turned on the nouveau 15 times before it 
finally stuck, just one example of many.

>Also, what is the driving problem here?  I know the log entry 'new
>patch_level=...' is missing, but what regression are you seeing that is
>caused by not updating the microcode?

On this system, when the microcode has not been updated, eg the "new patch 
level" line is missing in the above report, then I have stalls of up to 2 
or 3 minutes in the kmail composer, which is by far the busiest application 
here, like kmail has gone away doing something else. But if it is, then 
htop can't see it, and all of kmails background processes have been 
relegated to fetchmail/procmail/spamassassin/clam here for years for 
exactly that reason.  But the cpu's aren't showing a load in the gkrellm 
display, or in htop, both of which continues to function normally, and I 
can switch workspaces and all is well but come back to the kmail screen and 
the keyboard is dead, and the mouse pointer disappears when over the 
composer window.  When the report says it worked as above does, I don't get 
this oddity.  I would almost say its an interrupt problem, except that when 
it "wakes up" again, it will play catchup with what I typed.  But I don't 
type all that well blind. :)

So last night, finding it hard to believe the 3.8.3 makefile could be it, I 
started a new bisect, this time with 3.8.2 good, 3.8.4 bad, and will see 
what I get this time.  With my "makeit" script now tracking the version, it 
Just Works(TM), so all I have to do is reboot to the kernel I have it now 
reporting as it exits.

I know, this doesn't make sense, but I have been living with it since I 
built this box when a Phenom 9550 was cutting edge!  Thats why I will do 
yet another bisect.  If it nails the 3.8.3 makefile again, then the same 
error still exists in 3.12.6, it has never again successfully applied the 
AMD microcode since. But I have not built the intervening versions either 
so that is not a blanket statement.  So I'll be back when i have the final 
result of this new bisect again.

>thx,
>
>Jason.
Thanks for your patience Jason, there are times when I am fresh out.

Cheers, Gene
