Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3FZPOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:14:43 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4985 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab3FZPOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:14:40 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Date: Wed, 26 Jun 2013 20:52:44 +0530
From: "Kamlakant Patel" <kamlakant.patel@broadcom.com>
To: "Sourav Poddar" <sourav.poddar@ti.com>
cc: linux-mtd@lists.infradead.org, spi-devel-general@lists.sourceforge.net,
        broonie@kernel.org, dwmw2@infradead.org, manonuevo@micron.com,
        tqnguyen@micron.com, grant.likely@linaro.org,
        linux-omap@vger.kernel.org, rnayak@ti.com,
        linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH 1/3] drivers: mtd: spinand: Add generic spinand
 frameowrk and micron driver.
Message-ID: <20130626152243.GA9414@kpatel.netlogicmircro.com>
References: <1372232472-2641-1-git-send-email-sourav.poddar@ti.com>
 <1372232472-2641-2-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
In-Reply-To: <1372232472-2641-2-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-WSS-ID: 7DD5DC7F1R036792119-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 01:11:10PM +0530, Sourav Poddar wrote:
> From: Mona Anonuevo <manonuevo@micron.com>
> 
> This patch adds support for a generic spinand framework(spinand_mtd.c).
> This frameowrk can be used for other spi based flash devices also. The idea
> is to have a common model under drivers/mtd, as also present for other no spi
> devices(there is a generic framework and device part simply attaches itself to it.)
> 
> The generic frework will be used later by me for a SPI based spansion S25FL256 device.
> The patch also contains a micron driver attaching itself to generic framework.
> 
> Signed-off-by: Mona Anonuevo <manonuevo@micron.com>
> Signed-off-by: Tuan Nguyen <tqnguyen@micron.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ----
> [I picked this as a standalone patch, can split it into generic and device part
> based on community feedback.]
> 
>  drivers/mtd/Kconfig               |    2 +
>  drivers/mtd/Makefile              |    2 +
>  drivers/mtd/spinand/Kconfig       |   24 ++
>  drivers/mtd/spinand/Makefile      |   10 +
>  drivers/mtd/spinand/spinand_lld.c |  776 +++++++++++++++++++++++++++++++++++++
>  drivers/mtd/spinand/spinand_mtd.c |  690 +++++++++++++++++++++++++++++++++
>  include/linux/mtd/spinand.h       |  155 ++++++++
>  7 files changed, 1659 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mtd/spinand/Kconfig
>  create mode 100644 drivers/mtd/spinand/Makefile
>  create mode 100644 drivers/mtd/spinand/spinand_lld.c
>  create mode 100644 drivers/mtd/spinand/spinand_mtd.c
>  create mode 100644 include/linux/mtd/spinand.h
> 

I am working on Micron SPINAND(Micron MT29F1G01ZACH). I tried this patch, but it's not working.
It is throwing following error message while mounting:
[  260.232000] jffs2: cannot read OOB for EB at 00000000, requested 8 bytes, read 0 bytes, error -22
mount: mounting /dev/mtdblock5 on /mnt/ failed: Input/output error

I am working on it to fix into the driver, will send an updated patch with the fix.

Thanks,
Kamlakant Patel

