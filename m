Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab3HSLgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:36:13 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57192 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab3HSLgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:36:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,913,1367964000"; 
   d="scan'208";a="29733956"
Date: Mon, 19 Aug 2013 13:35:51 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: =?ISO-8859-15?Q?Svenning_S=F8rensen?= <sss@secomea.dk>
cc: Felipe Balbi <balbi@ti.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] usb: musb: dsps: simplify
 platform_get_resource_byname/devm_ioremap_resource
In-Reply-To: <5211FED3.4090102@secomea.dk>
Message-ID: <alpine.DEB.2.02.1308191334340.2313@hadrien>
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr> <1376902316-18520-5-git-send-email-Julia.Lawall@lip6.fr> <5211FED3.4090102@secomea.dk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-586657187-1376912151=:2313"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-586657187-1376912151=:2313
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT



On Mon, 19 Aug 2013, Svenning Sørensen wrote:

> On 19-08-2013 10:51, Julia Lawall wrote:
> > diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> > index 4ffbaac..f2f9710 100644
> > --- a/drivers/usb/musb/musb_dsps.c
> > +++ b/drivers/usb/musb/musb_dsps.c
> > @@ -357,9 +357,6 @@ static int dsps_musb_init(struct musb *musb)
> >   	u32 rev, val;
> >     	r = platform_get_resource_byname(parent, IORESOURCE_MEM, "control");
> > -	if (!r)
> > -		return -EINVAL;
> > -
> >   	reg_base = devm_ioremap_resource(dev, r);
> >   	if (!musb->ctrl_base)
> >   		return -EINVAL;
> Not really related to Julia's patch, apart from making it more obvious that
> there's a bug here.
> I believe it is reg_base that needs to be checked, right?

Indeed, it is all backwards.  I could extend the patch, if you want.

julia
--8323329-586657187-1376912151=:2313--
