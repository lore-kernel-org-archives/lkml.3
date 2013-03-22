Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab3CVPLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:11:25 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43730
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192Ab3CVPLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:11:24 -0400
Date: Fri, 22 Mar 2013 09:11:11 -0600
From: Jens Axboe <axboe@kernel.dk>
To: scameron@beardog.cce.hp.com
Cc: Wei Yongjun <weiyj.lk@gmail.com>, mike.miller@hp.com,
        akpm@linux-foundation.org, yongjun_wei@trendmicro.com.cn,
        iss_storagedev@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: fix invalid use of sizeof in
 cciss_find_cfgtables()
Message-ID: <20130322151111.GL25978@kernel.dk>
References: <CAPgLHd-8dxVHPbeZgcSu3XcyJozuws5YUftDO3W9W1OQVGy1Kw@mail.gmail.com>
 <20130314153025.GJ28545@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314153025.GJ28545@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14 2013, scameron@beardog.cce.hp.com wrote:
> On Thu, Mar 14, 2013 at 11:19:45PM +0800, Wei Yongjun wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > sizeof() when applied to a pointer typed expression gives the
> > size of the pointer, not that of the pointed data.
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > ---
> >  drivers/block/cciss.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > index ade58bc..1c1b8e5 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -4206,7 +4206,7 @@ static int cciss_find_cfgtables(ctlr_info_t *h)
> >  	if (rc)
> >  		return rc;
> >  	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
> > -		cfg_base_addr_index) + cfg_offset, sizeof(h->cfgtable));
> > +		cfg_base_addr_index) + cfg_offset, sizeof(*h->cfgtable));
> >  	if (!h->cfgtable)
> >  		return -ENOMEM;
> >  	rc = write_driver_ver_to_cfgtable(h->cfgtable);
> > 
> 
> Ack.
> 
> I suppose it has worked all this time because ioremap can't map less
> than a page, and sizeof(*h->cfgtable) is less than a page, and likely
> starts on a page boundary.

Queued up for 3.9, thanks.

-- 
Jens Axboe

