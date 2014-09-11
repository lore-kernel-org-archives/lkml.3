Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaIKOpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:45:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47066 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754598AbaIKOpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:45:39 -0400
Date: Thu, 11 Sep 2014 16:45:36 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <b32955@freescale.com>,
        Mike Voytovich <mvoytovich@paypal.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140911164536.796f1012@bbrezillon>
In-Reply-To: <20140911142930.GB2543@localhost.localdomain>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140911142930.GB2543@localhost.localdomain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014 22:29:32 +0800
Huang Shijie <shijie8@gmail.com> wrote:

> On Wed, Sep 10, 2014 at 10:55:39AM +0200, Boris BREZILLON wrote:
>  +static int gpmi_ecc_read_page_raw(struct mtd_info *mtd,
> > +				  struct nand_chip *chip, uint8_t *buf,
> > +				  int oob_required, int page)
> > +{
> > +	struct gpmi_nand_data *this = chip->priv;
> > +	struct bch_geometry *nfc_geo = &this->bch_geometry;
> > +	int eccsize = nfc_geo->ecc_chunk_size;
> > +	int eccbytes = DIV_ROUND_UP(nfc_geo->ecc_strength * nfc_geo->gf_len,
> > +				    8);
> 
> In actually, the ECC can be _NOT_ bytes aligned.
> you should not round up to byte.

You mean, on the NAND storage ? That would be weird, but I'll check.

When accessing in raw mode I'm not using the ECC engine (or at least
that's what I'm trying to achieve when using read_buf and not
gpmi_ecc_read_page).



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
