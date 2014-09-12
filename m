Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaILAlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 20:41:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:6370 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaILAlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 20:41:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,509,1406617200"; 
   d="scan'208";a="572050165"
Date: Fri, 12 Sep 2014 08:40:47 +0800
From: Huang Shijie <shijie.huang@intel.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Huang Shijie <shijie8@gmail.com>, Mike Voytovich <mvoytovich@paypal.com>,
        linux-kernel@vger.kernel.org, Huang Shijie <b32955@freescale.com>,
        linux-mtd@lists.infradead.org, Roy Lee <roylee@paypal.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140912004047.GA26904@shldeISGChi005.sh.intel.com>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140911142930.GB2543@localhost.localdomain>
 <20140911164536.796f1012@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140911164536.796f1012@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 04:45:36PM +0200, Boris BREZILLON wrote:
> On Thu, 11 Sep 2014 22:29:32 +0800
> Huang Shijie <shijie8@gmail.com> wrote:
> 
> > On Wed, Sep 10, 2014 at 10:55:39AM +0200, Boris BREZILLON wrote:
> >  +static int gpmi_ecc_read_page_raw(struct mtd_info *mtd,
> > > +				  struct nand_chip *chip, uint8_t *buf,
> > > +				  int oob_required, int page)
> > > +{
> > > +	struct gpmi_nand_data *this = chip->priv;
> > > +	struct bch_geometry *nfc_geo = &this->bch_geometry;
> > > +	int eccsize = nfc_geo->ecc_chunk_size;
> > > +	int eccbytes = DIV_ROUND_UP(nfc_geo->ecc_strength * nfc_geo->gf_len,
> > > +				    8);
> > 
> > In actually, the ECC can be _NOT_ bytes aligned.
> > you should not round up to byte.
> 
> You mean, on the NAND storage ? That would be weird, but I'll check.

yes. it is weird. 

thanks
Huang Shijie
