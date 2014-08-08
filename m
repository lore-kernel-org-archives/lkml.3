Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbaHHRFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:05:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40494 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756207AbaHHRFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:05:32 -0400
Date: Fri, 8 Aug 2014 14:04:28 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/27] mtd: nand: pxa3xx: show device structure in sysfs
Message-ID: <20140808170428.GA6094@arch.cereza>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
 <1401142372-14148-10-git-send-email-holler@ahsoftware.de>
 <1401160341.192042842@f271.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401160341.192042842@f271.i.mail.ru>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Picking on this old thread...

On 27 May 07:12 AM, Alexander Shiyan wrote:
> > diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> > index 7588fe2..7f62e7c 100644
> > --- a/drivers/mtd/nand/pxa3xx_nand.c
> > +++ b/drivers/mtd/nand/pxa3xx_nand.c
> > @@ -1584,8 +1584,7 @@ static int alloc_nand_resource(struct platform_device *pdev)
> >  		host->mtd = mtd;
> >  		host->cs = cs;
> >  		host->info_data = info;
> > -		mtd->priv = host;
> > -		mtd->owner = THIS_MODULE;
> > +		mtd_setup_common_members(mtd, host, pdev);
> >  
> >  		chip->ecc.read_page	= pxa3xx_nand_read_page_hwecc;
> >  		chip->ecc.write_page	= pxa3xx_nand_write_page_hwecc;
> > -- 
> 
> Should we add "driver.owner = THIS_MODULE" field for struct platform_driver in this case?
> 

As far as I can see, for platform drivers, the owner of the driver is fixed to
THIS_MODULE in __platform_driver_register().

If there's anything left to fix for this driver, please let me know.

Thanks,
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
