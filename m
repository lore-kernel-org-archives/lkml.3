Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbaISUHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:07:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36890 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbaISUG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:06:58 -0400
Date: Fri, 19 Sep 2014 13:06:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: Tree for Sep 19
Message-ID: <20140919200653.GA25785@roeck-us.net>
References: <20140919165817.225eb8b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919165817.225eb8b8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:58:17PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140917:
> 
> The fsl tree still had its build failure so I used the version from
> next-20140917.
> 
> The v4l-dvb tree lost its build failure.
> 
> The security tree gained a conflict against the file-locks tree.
> 
> Non-merge commits (relative to Linus' tree): 6014
>  5488 files changed, 217522 insertions(+), 129375 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
i386:allyesconfig:

mpt2sas_scsih.c:(.text+0xf52fc9): undefined reference to `__udivdi3'
mpt2sas_scsih.c:(.text+0xf52ffc): undefined reference to `__umoddi3'

i386:allmodconfig:

ERROR: "__udivdi3" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
ERROR: "__umoddi3" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!

Bisect points to commit daeaa9df92b ('mpt2sas: Avoid type casting for direct I/O
commands').

Bisect results:

# bad: [6a10bca9b608df445baa23c3bfafc510d93d425b] Add linux-next specific files for 20140919
# good: [9e82bf014195d6f0054982c463575cdce24292be] Linux 3.17-rc5
git bisect start 'HEAD' 'v3.17-rc5'
# good: [fde058e2322b9098251d7cf798cac4327a29c004] Merge remote-tracking branch 'drm/drm-next'
git bisect good fde058e2322b9098251d7cf798cac4327a29c004
# good: [8a258c1a0f82f4d152a3b06966a4d28dac2c8bcb] Merge remote-tracking branch 'usb-serial/usb-next'
git bisect good 8a258c1a0f82f4d152a3b06966a4d28dac2c8bcb
# good: [99dc94f3224855808ff22e36b82a3bdd4b16242e] drivers: staging: rtl8723au: Fix "space required before that '*'" errors
git bisect good 99dc94f3224855808ff22e36b82a3bdd4b16242e
# bad: [3c4f4ea8958e7cd1c0d904e43ac1c0ebfc5e31c5] Merge remote-tracking branch 'dma-mapping/dma-mapping-next'
git bisect bad 3c4f4ea8958e7cd1c0d904e43ac1c0ebfc5e31c5
# good: [094a06f2ab7f56471c28f90335c718d4f846869c] Merge remote-tracking branch 'staging/staging-next'
git bisect good 094a06f2ab7f56471c28f90335c718d4f846869c
# bad: [12aad94792718c6a79bbd395a650caff85f76ae4] arcmsr: revise message_isr_bh_fn to remove duplicate code
git bisect bad 12aad94792718c6a79bbd395a650caff85f76ae4
# good: [9ab9b134a86ed9f897a29d2ba5abb93f7b162dca] lpfc: mark function as static in lpfc/lpfc_bsg.c
git bisect good 9ab9b134a86ed9f897a29d2ba5abb93f7b162dca
# bad: [861ff736c8d8ae574dcc1ef81e5da84ff85e70c9] mpt3sas: MPI2.5 Rev G (2.5.2) specifications
git bisect bad 861ff736c8d8ae574dcc1ef81e5da84ff85e70c9
# good: [8c50d25c0edd8ec05a7e069c23f6ac2e50c898b1] lpfc: fix for handling unmapped ndlp in target reset handler
git bisect good 8c50d25c0edd8ec05a7e069c23f6ac2e50c898b1
# good: [e9edbe310dbb745067f7c5761ba91005fb9d60af] mpt2sas: Copyright in driver sources is updated for year the 2014
git bisect good e9edbe310dbb745067f7c5761ba91005fb9d60af
# bad: [daeaa9df92bd742f4e6d4d6039d689277a8e31bd] mpt2sas: Avoid type casting for direct I/O commands
git bisect bad daeaa9df92bd742f4e6d4d6039d689277a8e31bd
# good: [49563e1e4b202436a36409f365b0a96796db5aad] mpt2sas: Bump mpt2sas driver version to 17.100.00.00
git bisect good 49563e1e4b202436a36409f365b0a96796db5aad
# first bad commit: [daeaa9df92bd742f4e6d4d6039d689277a8e31bd] mpt2sas: Avoid type casting for direct I/O commands
