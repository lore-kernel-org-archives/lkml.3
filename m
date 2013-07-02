Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3GBVjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:39:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38448 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab3GBVjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:39:21 -0400
Message-ID: <1372801125.21065.99.camel@cumari.coelho.fi>
Subject: Re: [PATCH v2 8/9] wlcore: sdio: get clocks from device tree
From: Luciano Coelho <coelho@ti.com>
To: <balbi@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Wed, 3 Jul 2013 00:38:45 +0300
In-Reply-To: <20130702213208.GC10388@arwen.pp.htv.fi>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
	 <1372776948-24840-9-git-send-email-coelho@ti.com>
	 <20130702153526.GI7013@arwen.pp.htv.fi>
	 <1372796394.21065.89.camel@cumari.coelho.fi>
	 <20130702213208.GC10388@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 00:32 +0300, Felipe Balbi wrote:
> On Tue, Jul 02, 2013 at 11:19:54PM +0300, Luciano Coelho wrote:
> > On Tue, 2013-07-02 at 18:35 +0300, Felipe Balbi wrote:
> > > Hi,
> > > 
> > > On Tue, Jul 02, 2013 at 05:55:47PM +0300, Luciano Coelho wrote:
> > > > @@ -294,6 +316,8 @@ static int wl1271_probe(struct sdio_func *func,
> > > >  	/* Use block mode for transferring over one block size of data */
> > > >  	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
> > > >  
> > > > +	sdio_set_drvdata(func, glue);
> > > 
> > > is this move really necessary ?
> > 
> > It is, because I use the glue in wlcore_get_pdata_from_of(), so I need
> > to call sdio_set_drvdata() earlier.  I reckoned it wouldn't hurt to move
> > this, so I wouldn't have to pass the glue in the
> > wlcore_get_pdata_from_of() call.
> 
> that's alright, it does look like it deserves a mention in changelog
> though. Other than that:

Uh, ok.  This was so tiny (and I thought so obvious) a change that I
didn't mention it.  But if you asked about it, it was not obvious
enough. ;) I'll add a small comment about it in the commit message.


> Reviewed-by: Felipe Balbi <balbi@ti.com>

Thanks!

--
Luca.

