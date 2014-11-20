Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbaKTOq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 09:46:56 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:37008 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbaKTOqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 09:46:55 -0500
Date: Thu, 20 Nov 2014 06:46:47 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 20
Message-ID: <20141120144647.GA6022@roeck-us.net>
References: <20141120184653.7c7764ac@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120184653.7c7764ac@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.546DFEDE.02D3,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Thu, Nov 20, 2014 at 06:46:53PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20141119:
> 
> The asm-generic tree lost its build failure.
> 
> The omap_dss2 tree still had its build failure for which I applied a patch.
> 
> The devicetree tree gained a conflict against the devicetree-current tree.
> 
> Non-merge commits (relative to Linus' tree): 7146
>  7140 files changed, 242712 insertions(+), 180038 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
Build results:
	total: 133 pass: 130 fail: 3
Failed builds:
	arm:davinci_all_defconfig
	arm:orion5x_defconfig
	hexagon:defconfig

Qemu test results:
	total: 30 pass: 30 fail: 0

I assume the arm architecture folks will take care of the arm build failures,
so I did not have a look into those. The hexagon build failure is due to a
subtle change in files includes by other include files, resulting in a nested
dependency which is no longer met. That may be tricky to fix.

The qemu x86:nonsmp test only passes because I disabled PCI_MSI for this test.
Claim there is that qemu would not implement some IO_APIC related functionality
which is now mandatory.

Guenter
