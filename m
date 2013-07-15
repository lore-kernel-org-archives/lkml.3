Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3GOGuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:50:03 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:39221
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753975Ab3GOGuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:50:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 15 Jul 2013 14:49:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Robin Gong <b38343@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <rob@landley.net>
Subject: Re: [PATCH v2] regulator: pfuze100: add pfuze100 regulator driver
Message-ID: <20130715064949.GA11486@S2101-09.ap.freescale.net>
References: <1373604855-17714-1-git-send-email-b38343@freescale.com>
 <20130715012233.GA2730@S2101-09.ap.freescale.net>
 <20130715064037.GA4722@Robin-OptiPlex-780>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130715064037.GA4722@Robin-OptiPlex-780>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 02:40:39PM +0800, Robin Gong wrote:
> > > +static const struct of_device_id pfuze_dt_ids[] = {
> > > +	{ .compatible = "fsl,pfuze100", .data = (void *)PFUZE_ID_PFUZE100},
> > 
> > You do not use .data in the driver at all, and can just drop it.
> >
> good catch. .driver_data  of i2c_device_id and .data of of_device_id are two different ways to let driver know which chip used now by DTS or not. I should use them to know which chip used now ,although I can know by reading chipid register. 
> 

If you can figure out the chip ID from hardware, it should be used as
the preference over compatible and .driver_data.

Shawn

