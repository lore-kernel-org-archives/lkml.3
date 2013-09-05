Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238Ab3IELr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:47:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22080 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965199Ab3IELr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:47:26 -0400
Date: Thu, 5 Sep 2013 14:47:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wwang <wei_wang@realsil.com.cn>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        sameo@linux.intel.com, rogerable@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: rtsx: Modify rts5249_optimize_phy
Message-ID: <20130905114711.GM6329@mwanda>
References: <1378374338-11455-1-git-send-email-wei_wang@realsil.com.cn>
 <20130905104820.GL6329@mwanda>
 <52286822.9090402@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52286822.9090402@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 07:16:50PM +0800, wwang wrote:
> 于 2013年09月05日 18:48, Dan Carpenter 写道:
> >On Thu, Sep 05, 2013 at 05:45:38PM +0800, wei_wang@realsil.com.cn wrote:
> >>From: Wei WANG <wei_wang@realsil.com.cn>
> >>
> >>In some platforms, specially Thinkpad series, rts5249 won't be
> >>initialized properly. So we need adjust some phy parameters to
> >>improve the compatibility issue.
> >>
> >>Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> >>---
> >>  drivers/mfd/rts5249.c |   25 +++++++++++++++++++++++--
> >>  1 file changed, 23 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
> >>index 3b835f5..e3c6dc1 100644
> >>--- a/drivers/mfd/rts5249.c
> >>+++ b/drivers/mfd/rts5249.c
> >>@@ -130,13 +130,34 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
> >>  {
> >>  	int err;
> >>-	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, 0xFE46);
> >>+	err = rtsx_pci_write_phy_register(pcr, PHY_REG_REV, 0xFC6C);
> >
> >How are we supposed to review this change?  What happened to 0xFE46?
> >What are all these magic numbers?  I understand that this fixes an issue
> >for think pads but does it break something else?
> >
> >regards,
> >dan carpenter
> >
> >.
> >
> Hi Dan:
> 
> These numbers are used to configure the parameters of our internal
> analog circuit. Those new values have been tested for quite a long
> time with our Windows driver. So it's guaranteed and won't break
> other platforms.
> 

Give them human readable names so we at least have some idea about what
they are trying to do.

regards,
dan carpenter

