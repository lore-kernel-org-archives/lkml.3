Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaGGR4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:56:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59524 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751392AbaGGR4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:56:31 -0400
Date: Mon, 7 Jul 2014 19:56:27 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] memory: add a driver for atmel ram controllers
Message-ID: <20140707175627.GG3113@piout.net>
References: <1404746355-19988-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1404746355-19988-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20140707174642.65d02082@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707174642.65d02082@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/07/2014 at 17:46:42 +0200, Boris Brezillon wrote :
> On Mon,  7 Jul 2014 17:19:11 +0200
> Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> 
> > Atmel SoCs have one or multiple RAM controllers that need one or multiple clocks
> > to run.
> > This driver handle those clocks.
> > 
> 
> Actually this controller is an SDRAM controller which, depending on the
> SoC, might support SDR SDRAMs, DDR SDRAMs or both.
> 
> This is just a nitpick, but if you don't mind I'd rather replace
> references to RAMC by SDRAMC (ATMEL_RAMC -> ATMEL_SDRAMC) and just state
> that in some cases (at least this is the case for the DDRSDRC available
> in at91sam9g45 SoC) it supports both type of SDRAM (DDR and SDR).
> 
> The same goes for the source file name (atmel-ramc.c -> atmel-sdramc.c).
> 

will do.


> > diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> > index 16f60b41c147..54dc3aefb12a 100644
> > --- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
> > +++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> > @@ -61,6 +61,7 @@ RAMC SDRAM/DDR Controller required properties:
> >  - compatible: Should be "atmel,at91rm9200-sdramc",
> >  			"atmel,at91sam9260-sdramc",
> >  			"atmel,at91sam9g45-ddramc",
> > +			"atmel,sama5d3-mpddramc",
> >  - reg: Should contain registers location and length
> >    For at91sam9263 and at91sam9g45 you must specify 2 entries.
> 
> Shouldn't we move the documentation in
> Documentation/devicetree/bindings/memory-controllers/ (though this
> should be done in different patch).
> 

I guess we should move it later, to avoid merge conflicts


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
