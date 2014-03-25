Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaCYO6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 10:58:11 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:34339 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaCYO6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 10:58:09 -0400
Date: Tue, 25 Mar 2014 14:58:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        pekon@ti.com, computersforpeace@gmail.com, dwmw2@infradead.org
Subject: Re: [RFC 01/47] mtd: nand: export useful functions from core driver
Message-ID: <20140325145802.GC24823@lee--X1>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-2-git-send-email-lee.jones@linaro.org>
 <20140325125755.GD665@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140325125755.GD665@arch.cereza>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014, Ezequiel Garcia wrote:

> On Mar 25, Lee Jones wrote:
> > These functions are utilised by the STM BCH NAND Controller driver.
> > 
> [..]
> > -static int nand_suspend(struct mtd_info *mtd)
> > +int nand_suspend(struct mtd_info *mtd)
> >  {
> >  	return nand_get_device(mtd, FL_PM_SUSPENDED);
> >  }
> > +EXPORT_SYMBOL(nand_suspend);
> >  
> >  /**
> >   * nand_resume - [MTD Interface] Resume the NAND flash
> >   * @mtd: MTD device structure
> >   */
> > -static void nand_resume(struct mtd_info *mtd)
> > +void nand_resume(struct mtd_info *mtd)
> >  {
> >  	struct nand_chip *chip = mtd->priv;
> >  
> > @@ -2776,6 +2779,7 @@ static void nand_resume(struct mtd_info *mtd)
> >  		pr_err("%s called for a chip which is not in suspended state\n",
> >  			__func__);
> >  }
> > +EXPORT_SYMBOL(nand_resume);
> >  
> 
> The patch that adds the PM support for the driver makes no use of these.
> 
> Can you detail why do you need to export these?

Please see RFC PATCH 9:

mtd: nand: stm_nand_bch: introduce and initialise some important data structures

static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
                                   struct mtd_info *mtd, struct nand_chip *chip)
{

[...]
       mtd->_sync = nand_sync;
       mtd->_suspend = nand_suspend;
       mtd->_resume = nand_resume;
}

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
