Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaEHOSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:18:15 -0400
Received: from bastet.se.axis.com ([195.60.68.11]:47207 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaEHOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:18:12 -0400
From: Andreas =?iso-8859-1?q?Irest=E5l?= <andreas.irestal@axis.com>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH] net:Add basic DWC Ethernet QoS Driver
Date: Thu, 8 May 2014 16:18:04 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-bpo.2-amd64; KDE/4.4.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "abrodkin@synopsys.com" <abrodkin@synopsys.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>, "sr@denx.de" <sr@denx.de>,
        "jonas.jensen@gmail.com" <jonas.jensen@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jesper Nilsson <jespern@axis.com>, <peppe.cavallaro@st.com>
References: <201405081349.03139.Andreas.Irestal@axis.com> <20248221.mJ8pFfyc5U@wuerfel>
In-Reply-To: <20248221.mJ8pFfyc5U@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <201405081618.04475.Andreas.Irestal@axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Andreas Irestaal <Andreas.Irestal@axis.com>
> > ---
> >  drivers/net/ethernet/Kconfig                |    1 +
> >  drivers/net/ethernet/Makefile               |    1 +
> >  drivers/net/ethernet/synopsys/Kconfig       |   24 +
> >  drivers/net/ethernet/synopsys/Makefile      |    5 +
> >  drivers/net/ethernet/synopsys/dwc_eth_qos.c |  710 +++++++++++++++++++++++++++
> >  drivers/net/ethernet/synopsys/dwc_eth_qos.h |  308 ++++++++++++
> 
> Should we maybe move the dw_mac driver out of the stmicro directory into
> synopsys as a preparation, to keep them in the same place?
> 

That sounds like a good idea since that driver uses the same IP. I'm not the
person to take that decision though.

> > +
> > +	/* Set poll wait timeout to 2 seconds */
> > +	dwc_wait = 200;
> > +
> > +	while (lp->tx_descs[i].tdes3.wr.own) {
> > +		mdelay(10);
> > +		if (!dwc_wait--)
> > +			break;
> > +	}
> 
> This is really evil: you are blocking the CPU for up to two seconds!
> You already mentioned that this is work-in-progress, but I guess it has
> to be a little better than this and do something that doesn't block
> out the CPU during TX.
> 

It really is, but a 2s lockout is only happening upon TX failure. Anyway, this
won't be an issue in the final version, since it won't use polling for TX.

> 
> > +/* Fields/constants */
> > +#define DWCEQOS_DMA_MODE_SWR			1
> > +#define DWCEQOS_DMA_MODE_TXPR			(1 << 11)
> > +#define DWCEQOS_DMA_MODE_DA			(1 << 1)
> > +#define DWCEQOS_DMA_SYSBUS_MB			(1 << 14)
> 
> I find it more readable to use hexadecimal notation here
> 
> #define DWCEQOS_DMA_MODE_SWR		0x0001
> #define DWCEQOS_DMA_MODE_DA		0x0002
> #define DWCEQOS_DMA_MODE_TXPR		0x0800
> #define DWCEQOS_DMA_SYSBUS_MB		0x4000
> 

I agree, but it's not 100% clear which one is preferred as there exist drivers
using the first notation style. Anyway, I'll use the hex notation in future
patches since you prefer it.

Thanks for all valuable input. This was exactly the kind of feedback i was looking for

/Andreas


