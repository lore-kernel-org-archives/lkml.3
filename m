Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbbAWSey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:34:54 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53613 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbAWSev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:34:51 -0500
Date: Fri, 23 Jan 2015 10:34:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: linux-next: Tree for Jan 23
Message-ID: <20150123183444.GA337@roeck-us.net>
References: <20150123181029.35e688d1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150123181029.35e688d1@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54C2944B.00B6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Fri, Jan 23, 2015 at 06:10:29PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> There will be no linux-next release on Monday (next-20150126).
> 
> Changes since 20150122:
> 
> Added tree:	kvms390
> Removed tree:	documentation (at maintainers request)
> 
> The vfs tree gained a conflict against Linus' tree.
> 
> The akpm tree lost a patch that turned up elsewhere.
> 
> Non-merge commits (relative to Linus' tree): 4500
>  4390 files changed, 174556 insertions(+), 78123 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
xtensa:allmodconfig fails with:

drivers/gpu/drm/drm_gem_cma_helper.c: In function ‘drm_gem_cma_create’:
drivers/gpu/drm/drm_gem_cma_helper.c:110:2: error: implicit declaration of
function ‘dma_alloc_writecombine’ [-Werror=implicit-function-declaration]
drivers/gpu/drm/drm_gem_cma_helper.c:110:17: warning: assignment makes pointer
from integer without a cast [enabled by default]
drivers/gpu/drm/drm_gem_cma_helper.c: In function ‘drm_gem_cma_free_object’:
drivers/gpu/drm/drm_gem_cma_helper.c:193:3: error: implicit declaration of
function ‘dma_free_writecombine’ [-Werror=implicit-function-declaration]
drivers/gpu/drm/drm_gem_cma_helper.c: In function ‘drm_gem_cma_mmap_obj’:
drivers/gpu/drm/drm_gem_cma_helper.c:330:2: error: implicit declaration of
function ‘dma_mmap_writecombine’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[3]: *** [drivers/gpu/drm/drm_gem_cma_helper.o] Error 1

Ultimately caused by 'drm: add Atmel HLCDC Display Controller support',
which selects DRM_GEM_CMA_HELPER.
DRM_ATMEL_HLCDC seems to be missing some dependencies, or possibly
DRM_GEM_CMA_HELPER (and/or every driver selecting it) needs to depend
on HAVE_DMA_ATTRS.

Ultimately this may result in allmodconfig/allyesconfig build failures
on all architectures which don't define HAVE_DMA_ATTRS.

Guenter
