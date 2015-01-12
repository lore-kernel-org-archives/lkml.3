Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbbALQYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:24:54 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:45649 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbbALQYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:24:51 -0500
Date: Mon, 12 Jan 2015 08:24:38 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-m68k@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 12 (build failures: m68k, ppc)
Message-ID: <20150112162438.GA18723@roeck-us.net>
References: <20150112180322.003b44f2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112180322.003b44f2@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54B3F553.0139,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 06:03:22PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20150109:
> 
> The usb-gadget-fixes tree gained a conflict against the usb.current tree.
> 
> The net-next tree gained a build failure for which I reverted a commit.
> 
> The pinctrl tree gained a build failure so I used the version from
> next-20150109.
> 
> The akpm tree lost a few patches that turned up elsewhere.
> 
> Non-merge commits (relative to Linus' tree): 2202
>  2272 files changed, 69868 insertions(+), 38441 deletions(-)
> 

Build failures, seen since next-20150109:
	m68k:allmodconfig
	powerpc:ppc6xx_defconfig

Due to:
	ERROR: "__get_user_bad" [drivers/gpu/drm/drm.ko] undefined!
	make[1]: *** [__modpost] Error 1

Caused by commit d34f20d6e2f (drm: Atomic modeset ioctl).

Bisect results:

# bad: [39b673bba50275b516543d32ef78767a524b9f26] Add linux-next specific files for 20150109
# good: [b1940cd21c0f4abdce101253e860feff547291b0] Linux 3.19-rc3
git bisect start 'HEAD' 'v3.19-rc3'
# good: [d01312ff089667b0b996228ca165d4a9c124b28f] Merge remote-tracking branch 'net-next/master'
git bisect good d01312ff089667b0b996228ca165d4a9c124b28f
# bad: [b90b3ee4f96067f9eb2edf9e61c9f6356b796232] Merge remote-tracking branch 'device-mapper/for-next'
git bisect bad b90b3ee4f96067f9eb2edf9e61c9f6356b796232
# bad: [d4a32441dd063fd10f41826a69dea2b3f410501a] Merge remote-tracking branch 'drm-intel/for-linux-next'
git bisect bad d4a32441dd063fd10f41826a69dea2b3f410501a
# good: [d01203fd1b8c822adbadb0f0e417a7d344456150] Merge remote-tracking branch 'crypto/master'
git bisect good d01203fd1b8c822adbadb0f0e417a7d344456150
# good: [2be57922d46fdec4360ced2eb108832c5a90bc0e] drm/i915: Fix CRC support for DP port D on CHV
git bisect good 2be57922d46fdec4360ced2eb108832c5a90bc0e
# bad: [4baddea51fe5d73a4f2226e9febc6da21e11bac0] Merge remote-tracking branch 'drm/drm-next'
git bisect bad 4baddea51fe5d73a4f2226e9febc6da21e11bac0
# good: [72a3697097b8dc92f5b8362598f5730a9986eb83] Merge branch 'topic/core-stuff' into topic/atomic-core
git bisect good 72a3697097b8dc92f5b8362598f5730a9986eb83
# bad: [a97df1ccd3c30f16385696964767adf854878021] drm/atomic: Hide drm.ko internal interfaces
git bisect bad a97df1ccd3c30f16385696964767adf854878021
# good: [88a48e297b3a3bac6022c03babfb038f1a886cea] drm: add atomic properties
git bisect good 88a48e297b3a3bac6022c03babfb038f1a886cea
# good: [6b4959f43a04e12d39c5700607727f2cbcfeac31] drm/atomic: atomic plane properties
git bisect good 6b4959f43a04e12d39c5700607727f2cbcfeac31
# bad: [d34f20d6e2f21bd3531b969dc40913181a8ae31a] drm: Atomic modeset ioctl
git bisect bad d34f20d6e2f21bd3531b969dc40913181a8ae31a
# good: [ae16c597b61ae4613b13a0c3fac302e8d8827ac7] drm/atomic: atomic connector properties
git bisect good ae16c597b61ae4613b13a0c3fac302e8d8827ac7
# first bad commit: [d34f20d6e2f21bd3531b969dc40913181a8ae31a] drm: Atomic modeset ioctl
