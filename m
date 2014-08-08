Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbaHHRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:16:56 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42007 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbaHHRQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:16:54 -0400
Date: Fri, 8 Aug 2014 10:16:50 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Alexander Shiyan <shc_work@mail.ru>,
        Alexander Holler <holler@ahsoftware.de>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/27] mtd: nand: pxa3xx: show device structure in sysfs
Message-ID: <20140808171650.GS3711@ld-irv-0074>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
 <1401142372-14148-10-git-send-email-holler@ahsoftware.de>
 <1401160341.192042842@f271.i.mail.ru>
 <20140808170428.GA6094@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808170428.GA6094@arch.cereza>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 02:04:28PM -0300, Ezequiel Garcia wrote:
> Picking on this old thread...
> 
> On 27 May 07:12 AM, Alexander Shiyan wrote:
> > > diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
> > > index 7588fe2..7f62e7c 100644
> > > --- a/drivers/mtd/nand/pxa3xx_nand.c
> > > +++ b/drivers/mtd/nand/pxa3xx_nand.c
> > > @@ -1584,8 +1584,7 @@ static int alloc_nand_resource(struct platform_device *pdev)
> > >  		host->mtd = mtd;
> > >  		host->cs = cs;
> > >  		host->info_data = info;
> > > -		mtd->priv = host;
> > > -		mtd->owner = THIS_MODULE;
> > > +		mtd_setup_common_members(mtd, host, pdev);
> > >  
> > >  		chip->ecc.read_page	= pxa3xx_nand_read_page_hwecc;
> > >  		chip->ecc.write_page	= pxa3xx_nand_write_page_hwecc;
> > > -- 
> > 
> > Should we add "driver.owner = THIS_MODULE" field for struct platform_driver in this case?
> > 
> 
> As far as I can see, for platform drivers, the owner of the driver is fixed to
> THIS_MODULE in __platform_driver_register().

Looks like it. So any driver using module_platform_driver() or
platform_driver_register() and also initializes
platform_driver.driver.owner is just being redundant.

Maybe another "cleanup" project for Jingoo Han? ;)

> If there's anything left to fix for this driver, please let me know.

pxa3xx_nand is still missing a parent for its MTD's (mtd->dev.parent). I
have a follow-up patch queued up locally that I need to send out
sometime.

Brian
