Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340Ab3BMUxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:53:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760430Ab3BMUxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:53:21 -0500
Date: Wed, 13 Feb 2013 15:53:13 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130213205313.GA31374@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130212193901.GA18906@redhat.com>
 <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com>
 <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com>
 <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com>
 <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 11:56:25AM -0800, Linus Torvalds wrote:

 > Note that there is only ever one "bad" commit - since all the commits
 > you test while bisecting are by definition reachable from the previous
 > bad one and both contain the bug, picking a bad commit makes all other
 > previous bad commits uninteresting. So you just need to look at the
 > last bad commit, not the whole set of bad commits. So when re-doing
 > the bisect, and if you trust that your bad kernels really were bad and
 > had the *right* badness, you can just start with "git bisect bad
 > <last-bad-commit>"
 > 
 > (good commits, on the other hand, are independent of each other: "not
 > containing the bug" is not some kind of exclusivity test, so finding
 > one good kernel doesn't make the information about other good kernels
 > irrelevant)

I've tried working my way back up the bisect and then retesting some
of those 'good' branches, but every time I feel like I'm getting somewhere,
I get another result that makes no sense.

The latest for example ends like this..

# bad: [ddffeb8c4d0331609ef2581d84de4d763607bd37] Linux 3.7-rc1
git bisect bad ddffeb8c4d0331609ef2581d84de4d763607bd37
# good: [a0d271cbfed1dd50278c6b06bead3d00ba0a88f9] Linux 3.6
git bisect good a0d271cbfed1dd50278c6b06bead3d00ba0a88f9
# good: [24d7b40a60cf19008334bcbcbd98da374d4d9c64] ARM: OMAP2+: PM: MPU DVFS: use generic CPU device for MPU-SS
git bisect good 24d7b40a60cf19008334bcbcbd98da374d4d9c64
# good: [21c8715f0a1f4df8bfa2bd6f3915e5e33c1c2e6e] ARM: integrator: use __iomem pointers for MMIO, part 2
git bisect good 21c8715f0a1f4df8bfa2bd6f3915e5e33c1c2e6e
# good: [23d5385f382a7c7d8b6bf19b0c2cfb3acbb12d31] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
git bisect good 23d5385f382a7c7d8b6bf19b0c2cfb3acbb12d31
# good: [35e9a274fdc9c8feb763e4970a32d7089f51393c] Merge branch 'kconfig' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
git bisect good 35e9a274fdc9c8feb763e4970a32d7089f51393c
# bad: [e225ca27057e70e7cbb14ae4c1e5f758973af645] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc
git bisect bad e225ca27057e70e7cbb14ae4c1e5f758973af645
# good: [4f1cd91497774488ed16119ec3f54b3daf1561de] Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect good 4f1cd91497774488ed16119ec3f54b3daf1561de
# bad: [4e21fc138bfd7fe625ff5dc81541399aaf9d429b] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal
git bisect bad 4e21fc138bfd7fe625ff5dc81541399aaf9d429b
# bad: [ccff9b1db693062b0a9c9070f4304deb47ef215c] Merge tag 'stable/for-linus-3.7-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen
git bisect bad ccff9b1db693062b0a9c9070f4304deb47ef215c
# good: [5b3900cd409466c0070b234d941650685ad0c791] timekeeping: Cast raw_interval to u64 to avoid shift overflow
git bisect good 5b3900cd409466c0070b234d941650685ad0c791
# bad: [0588f1f934791b79d0a1e9b327be9b6eb361d2b8] Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 0588f1f934791b79d0a1e9b327be9b6eb361d2b8
# bad: [9d55ab71b735621a63c8923ba934d87879847cef] Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 9d55ab71b735621a63c8923ba934d87879847cef
# bad: [d677124b1fc3b2706a13e92f1b329f1ac77e5f20] rcu: Advise most users not to enable RCU user mode
git bisect bad d677124b1fc3b2706a13e92f1b329f1ac77e5f20
# bad: [a4fbe35a124526e6759be07bd9c7ea796ba1e00d] rcu: Grace-period initialization excludes only RCU notifier
git bisect bad a4fbe35a124526e6759be07bd9c7ea796ba1e00d

Which points out something in tree-rcu.  Which I don't even have compiled in,
because I have CONFIG_PREEMPT set.

I'll keep trying some of the earlier good branches in case I missed something.

	Dave

