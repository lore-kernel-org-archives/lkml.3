Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbbA0Rbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:31:38 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:37803 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701AbbA0Rbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:31:36 -0500
Date: Tue, 27 Jan 2015 09:31:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: Re: linux-next: Tree for Jan 27 (build failures due to 'don't offset
 memmap for flatmem')
Message-ID: <20150127173128.GA1555@roeck-us.net>
References: <20150127195123.46885d96@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127195123.46885d96@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C7CB77.039E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Tue, Jan 27, 2015 at 07:51:23PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20150123:
> 
> The arm64 tree gained a conflict against Linus' tree.
> 
> The net-next tree gained conflicts against the arm-soc and net trees.
> 
> The drm-panel tree gained a conflict against the drm tree.
> 
> The wireless-drivers-next tree gained a build failure for which I reverted
> a commit.
> 
> The block tree gained conflicts against the vfs and Linus' trees.
> 
> The clockevents tree gained a conflict against the arm tree.
> 
> The akpm tree lost a patch that turned up elsewhere.
> 
> Non-merge commits (relative to Linus' tree): 5237
>  4877 files changed, 200964 insertions(+), 94565 deletions(-)
> 
There are various build failures due to commit
	'mm/page_alloc.c: don't offset memmap for flatmem',
which assumes that ARCH_PFN_OFFSET is defined for all architectures,
but it isn't. This is also the first use of ARCH_PFN_OFFSET outside
an architecture directory.

Build fails for mn10300, m68k_nommu, and avr32.

Guenter
