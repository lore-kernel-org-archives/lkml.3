Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab3L2TtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 14:49:21 -0500
Received: from mail.wdtv.com ([66.118.69.84]:38173 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab3L2TtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 14:49:20 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [BUG BISECTED FAILED] Phenom microcode revision mis-identified
Date: Sun, 29 Dec 2013 14:49:16 -0500
Cc: linux-kernel@vger.kernel.org
References: <201312291224.03854.gheskett@wdtv.com> <201312291247.02384.gheskett@wdtv.com> <20131229191423.GQ19878@titan.lakedaemon.net>
In-Reply-To: <20131229191423.GQ19878@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201312291449.16667.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 December 2013, Jason Cooper wrote:
>On Sun, Dec 29, 2013 at 12:47:02PM -0500, Gene Heskett wrote:
>> On Sunday 29 December 2013, Gene Heskett wrote:
>> >Resend, incorrect subject line
>> >
>> >Here is the copy/paste of the final git bisect bad report:
>> >
>> >First, the reason for the bisect:
>> >gene@coyote:~/linux-stable$ dmesg | grep -A2 microcode
>> >[    0.518304] microcode: CPU0: patch_level=0x01000065
>> >[    0.518396] microcode: CPU1: patch_level=0x01000065
>> >[    0.518498] microcode: CPU2: patch_level=0x01000065
>> >[    0.518593] microcode: CPU3: patch_level=0x01000065
>> >[    0.518745] microcode: Microcode Update Driver: v2.00
>> ><tigran@aivazian.fsnet.co.uk>, Peter Oruba
>> >
>> >The output above should have in each cpu case, a second, or final line
>> >showing a patch level 0x0100083 in all cases.
>> >This failure is on an AMD phenom 9550 equipt machine.
>> >
>> >I can and have built from the tarball pull, a 3.8.2 which does work
>> >correctly.  The tarball build of 3.8.3 fails as above, and a tarball
>> >build of 3.12.6 still fails.
>> >
>> >gene@coyote:~/linux-stable$ git bisect bad
>> >908e88f285b909011dc7dbce5abaacf123f2f68d is the first bad commit
>> >commit 908e88f285b909011dc7dbce5abaacf123f2f68d
>> >Author: Russell King <rmk+kernel@arm.linux.org.uk>
>> >Date:   Mon Feb 25 16:09:12 2013 +0000
>> >
>> >I'll next do a "git checkout v3.8.2" to double check that it works.
>
>Please re-read the manpage for git bisect, particularly the section
>"Basic bisect commands".  You need to keep repeating building and
>booting the kernel, execute 'git bisect [good|bad]', as git bisect
>checks out different commits to try.  Depending on the number of
>commits, it can take 7 to 10 iterations before it nails it down to the
>bad commit.
>
>$ git log --oneline v3.8.2..v3.8.3 | wc -l
>103
>
>So you started at v3.8.3, said v3.8.2 is good.  git bisect will then
>checkout a commit in the middle (of the 103 commits to choose from).  You
>need to build that kernel, boot it, and see if the error occurs.  Then,
>type 'git bisect [bad|good]' depending on what happened.  When that
>command returns, it has checked out a different commit between v3.8.2
>and v3.8.3.  Build, boot, and run 'git bisect [good|bad]' depending on
>if the patch_level was reported properly.  Repeat until it reports
>nothing left to test.
>
>> FWIW, a git checkout v3.8.2  also fails, so next I'll move my working
>> tarball build .configs into that tree & see if it works.
>
>If the config you started with worked for v3.8.2 and didn't for v3.8.3,
>keep using it.
>
>> This is getting stranger, a checkout v3.8.2 is supposed to match the
>> tarball I got from kernel.org isn't it?
>
>Yes, see above.  As soon as you started the bisection process, you were
>no longer on version 3.8.2 or 3.8.3, but somewhere in between.  That's
>what's supposed to happen.
>
>Once you run enough iterations to get nothing left to test, record the
>commit it identified, and run 'git bisect reset'.
I did do that, the above report was the final of about 8 or 9 reboots after 
telling it each time "git bisect bad".

And that "reset" is what I did not do just now.  Instead, I went directly 
to git checkout v3.8.2, then moved a known good pair of configs (which now 
give me no option to build the 64 bit kernel as the first line in a make 
xconfig)

Then, because it was still building a bunch of stuff that aren't applicable 
to my hardware, so I stripped several pages worth of modules, and a new 
3.8.2 from linux-stable is building now.  But it will take 20 minutes 
longer.  If this doesn't work, then I'll copy these .configs back to that 
tarball tree and try that.  One things is for sure, I'm keeping my coffee 
warm on that phenom. ;-)

If it then works for the tarball built kernel, then I'll do the git bisect 
reset and restart, doing the bisect all over again.  But this time I'll 
start it at a checkout v3.8.2, git bisect good (if it works now) and  go 
toward v3.8.3 bad.

These will all be 32 bit PAE kernels though as I don't know how to convert 
it to 64 bit when a make xconfig doesn't give me that option.

Thanks Jason.
>
>Jason.


Cheers, Gene
