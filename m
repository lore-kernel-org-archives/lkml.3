Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbbA2CI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:08:26 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:42064 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761299AbbA2CHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:07:18 -0500
Date: Wed, 28 Jan 2015 10:50:52 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Introduce <linux/mm_struct.h>
Message-ID: <20150128185052.GA6118@roeck-us.net>
References: <1422451064-109023-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422451064-109023-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020206.54C92F92.01EC,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 4
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

On Wed, Jan 28, 2015 at 03:17:40PM +0200, Kirill A. Shutemov wrote:
> This patchset moves definition of mm_struct into separate header file.
> It allows to get rid of nr_pmds if PMD page table level is folded.
> We cannot do it with current mm_types.h because we need
> __PAGETABLE_PMD_FOLDED from <asm/pgtable.h> which creates circular
> dependencies.
> 
> I've done few build tests and looks like it works, but I expect breakage
> on some configuration. Please test.
> 
Doesn't look good.

Build results:
	total: 134 pass: 63 fail: 71
Failed builds:
	arm:s3c2410_defconfig
	arm:omap2plus_defconfig
	arm:imx_v6_v7_defconfig
	arm:ixp4xx_defconfig
	arm:u8500_defconfig
	arm:multi_v5_defconfig
	arm:multi_v7_defconfig
	arm:omap1_defconfig
	arm:footbridge_defconfig
	arm:davinci_all_defconfig
	arm:mini2440_defconfig
	arm:rpc_defconfig
	arm:axm55xx_defconfig
	arm:mxs_defconfig
	arm:keystone_defconfig
	arm:vexpress_defconfig
	arm:imx_v4_v5_defconfig
	arm:at91_dt_defconfig
	arm:s3c6400_defconfig
	arm:lpc32xx_defconfig
	arm:shmobile_defconfig
	arm:nhk8815_defconfig
	arm:bcm2835_defconfig
	arm:sama5_defconfig
	arm:orion5x_defconfig
	arm:exynos_defconfig
	arm:cm_x2xx_defconfig
	arm:s5pv210_defconfig
	arm:integrator_defconfig
	arm:msm_defconfig
	arm:pxa910_defconfig
	arm:clps711x_defconfig
	avr32:defconfig
	avr32:merisc_defconfig
	avr32:atngw100mkii_evklcd101_defconfig
	cris:defconfig
	cris:etrax-100lx_defconfig
	cris:allnoconfig
	cris:artpec_3_defconfig
	cris:etraxfs_defconfig
	frv:defconfig
	hexagon:defconfig
	ia64:defconfig
	m68k:defconfig
	m68k:allmodconfig
	m68k:sun3_defconfig
	m68k:m5475evb_defconfig
	microblaze:mmu_defconfig
	mips:allmodconfig
	powerpc:ppc6xx_defconfig
	powerpc:mpc83xx_defconfig
	powerpc:mpc85xx_defconfig
	powerpc:mpc85xx_smp_defconfig
	powerpc:tqm8xx_defconfig
	powerpc:85xx/sbc8548_defconfig
	powerpc:83xx/mpc834x_mds_defconfig
	powerpc:86xx/sbc8641d_defconfig
	powerpc:ppc6xx_defconfig
	powerpc:mpc83xx_defconfig
	powerpc:mpc85xx_defconfig
	powerpc:mpc85xx_smp_defconfig
	powerpc:tqm8xx_defconfig
	powerpc:85xx/sbc8548_defconfig
	powerpc:83xx/mpc834x_mds_defconfig
	powerpc:86xx/sbc8641d_defconfig
	s390:defconfig
	sparc32:defconfig
	sparc64:defconfig
	sparc64:allmodconfig
	unicore32:defconfig
	xtensa:allmodconfig

Qemu tests:
	total: 30 pass: 20 fail: 10
Failed tests:
	arm:arm_versatile_defconfig
	arm:arm_vexpress_defconfig
	microblaze:microblaze_defconfig
	microblaze:microblazeel_defconfig
	powerpc:ppc_book3s_defconfig
	powerpc:ppc_book3s_smp_defconfig
	sparc32:sparc_defconfig
	sparc32:sparc_smp_defconfig
	sparc64:sparc_smp_defconfig
	sparc64:sparc_nosmp_defconfig

A few of those are other problems, but the majority is due to your patches.

Details are available at http://server.roeck-us.net:8010/builders;
look for the 'testing' column.

Guenter
