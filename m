Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaACOz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 09:55:57 -0500
Received: from mail.wdtv.com ([66.118.69.84]:49297 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaACOzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:55:55 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Subject: Re: AMD microcode fails to update with v3.8.3 and newer, bisect failed
Date: Fri, 3 Jan 2014 09:55:45 -0500
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
References: <201401011752.00267.gheskett@wdtv.com> <20140102181513.GA9391@milliways> <201401021812.05431.gheskett@wdtv.com>
In-Reply-To: <201401021812.05431.gheskett@wdtv.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201401030955.45645.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 January 2014, Gene Heskett wrote:
>On Thursday 02 January 2014, Ken Moffat wrote:
>>On Thu, Jan 02, 2014 at 12:24:56AM -0500, Gene Heskett wrote:
>>> On Wednesday 01 January 2014, Ken Moffat wrote:
>>> >On Thu, Jan 02, 2014 at 04:08:15AM +0000, Ken Moffat wrote:
>>> >>  Anyway, best of luck and I hope you get it sorted.
[...]
>My "makeit" script actually stores the .config as a config-$VER.gz in the
>boot, renaming an existing one to gz.old if its found.  But that was
>apparently overwritten more than twice while attempting the bisect.
>
>No progress today, I've been out playing small town broadcast engineer,
>the local AM'ers daytime transmitter put out about 1 kilgram of smoke at
>turn on this morning.  A gassy 807 took out a 10 henry choke in the
>power supply about 10kg, but now nice and toasty overdone.  Parts on
>order, but are up in PA, and this current snowstorm has PA in just about
>in a total lockdown. Might have it by Monday.
>
>Cheers, Gene

This morning I may have found a clue.  The last thing I did last night was 
to note that in the boots where it worked, the module microcode was a 
MODULE, not built in.  So I made a boot with only that change, after having 
built a previous boot with all the ext# stuff built in too.

I am booted to 3.12.6, 32 bit build on a phenom cpu, it IS recognizing all 
8Gb of my memory, and:

gene@coyote:~/src/linux-3.12.6$ dmesg|grep microcode
[   22.572212] microcode: CPU0: patch_level=0x01000065
[   22.573242] microcode: CPU0: new patch_level=0x01000083
[   22.573256] microcode: CPU1: patch_level=0x01000065
[   22.573263] microcode: CPU1: new patch_level=0x01000083
[   22.573273] microcode: CPU2: patch_level=0x01000065
[   22.573281] microcode: CPU2: new patch_level=0x01000083
[   22.573293] microcode: CPU3: patch_level=0x01000065
[   22.573301] microcode: CPU3: new patch_level=0x01000083
[   22.573377] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba

So the microcode updating does not work when built in.

So the $64k questions are, 1. does it work for anyone else when built in? 
and 2. is it supposed to?

Obviously if it is supposed to work, why not?  I'm not equipt to do much 
more than report.  The coal mines canary comes to mind.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

I'm not tense, just terribly, terribly alert!
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.
