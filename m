Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbbAMVVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:21:16 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:47777 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbbAMVVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:21:15 -0500
Date: Tue, 13 Jan 2015 13:21:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Peter Robinson <pbrobinson@gmail.com>, Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: Tree for Jan 13 (arm build failure)
Message-ID: <20150113212100.GA26229@roeck-us.net>
References: <20150113174128.7c108b18@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113174128.7c108b18@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A010203.54B58C4B.003D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Tue, Jan 13, 2015 at 05:41:28PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20150112:
> 
> The imx-mxs tree gained a conflict against the arm-soc tree.
> 
> The mvebu tree gained a conflict against the arm-soc tree.
> 
> The net-next tree lost its build failure.
> 
> The usb-gadget tree gained conflicts against the usb.current tree.
> 
> The pinctrl tree lost its build failure.
> 
> The akpm-current tree gained a conflict against the char-misc tree.
> 
> Non-merge commits (relative to Linus' tree): 2710
>  2658 files changed, 84945 insertions(+), 45898 deletions(-)
> 

New arm build failure.

Building arm:imx_v6_v7_defconfig ... failed
--------------
Error log:
make[1]: *** No rule to make target 'arch/arm/boot/dts/dtb-', needed by
'__build'.  Stop.
make[1]: *** Waiting for unfinished jobs....
make: *** [dtbs] Error 2

Bisect points to commit 6f1650f15bc ("ARM: dts: Only build dtb if associated
Arch and/or SoC is enabled").

Bisect log:

# bad: [8fb4ab29bd8400e0060662208573d26b9d91656d] Add linux-next specific files for 20150113
# good: [eaa27f34e91a14cdceed26ed6c6793ec1d186115] linux 3.19-rc4
git bisect start 'HEAD' 'v3.19-rc4'
# bad: [0f04a3e03c6c4cc1517c8c547ecda111e74172cb] Merge remote-tracking branch 'crypto/master'
git bisect bad 0f04a3e03c6c4cc1517c8c547ecda111e74172cb
# bad: [66e002178d280b322673581b7ad4c60c46d760fd] Merge remote-tracking branch 'hid/for-next'
git bisect bad 66e002178d280b322673581b7ad4c60c46d760fd
# bad: [5ec2a5866c07b96000ac1134cf50062c9b2e0c9b] Merge remote-tracking branch 'renesas/next'
git bisect bad 5ec2a5866c07b96000ac1134cf50062c9b2e0c9b
# bad: [6d7f85f3a7267ec23bd288349b46c420edf16045] Merge remote-tracking branch 'arm-soc/for-next'
git bisect bad 6d7f85f3a7267ec23bd288349b46c420edf16045
# good: [8b18ad4af2253216b7bda6e965b61542c511d0a7] Merge remote-tracking branch 'kselftest-fixes/fixes'
git bisect good 8b18ad4af2253216b7bda6e965b61542c511d0a7
# good: [87a7313a2e8fd9480b65cea5c757367c3d97a4bc] Merge branch 'next/cleanup' into for-next
git bisect good 87a7313a2e8fd9480b65cea5c757367c3d97a4bc
# good: [0dc4849528ddb9202261bfa3b22489e3b0f8702e] Merge tag 'renesas-dt-for-v3.20' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/dt
git bisect good 0dc4849528ddb9202261bfa3b22489e3b0f8702e
# good: [5be75b7ccc6c21f9c383c81f694a0b4827d40382] Merge branch 'next/drivers' into for-next
git bisect good 5be75b7ccc6c21f9c383c81f694a0b4827d40382
# good: [44d5c32889d07db9f85d556aa80d165c4b5234e6] Merge remote-tracking branch 'arc/for-next'
git bisect good 44d5c32889d07db9f85d556aa80d165c4b5234e6
# good: [c25aad6318d5da472154d065067b6255f197fc46] Merge tag 'renesas-soc-for-v3.20' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/soc
git bisect good c25aad6318d5da472154d065067b6255f197fc46
# bad: [f6fd9d4142dc5d4916f9588d6da127497dcf5755] Merge branch 'next/dt' into for-next
git bisect bad f6fd9d4142dc5d4916f9588d6da127497dcf5755
# good: [4941a517af17b240312ae43f676bbff3f2fa2ad1] Merge branch 'next/soc' into for-next
git bisect good 4941a517af17b240312ae43f676bbff3f2fa2ad1
# bad: [6f1650f15bc4dda88be37fdfa0490e5a4ea4a6f0] ARM: dts: Only build dtb if associated Arch and/or SoC is enabled
git bisect bad 6f1650f15bc4dda88be37fdfa0490e5a4ea4a6f0
# first bad commit: [6f1650f15bc4dda88be37fdfa0490e5a4ea4a6f0] ARM: dts: Only build dtb if associated Arch and/or SoC is enabled

Guenter
