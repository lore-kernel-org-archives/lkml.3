Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaCUFhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 01:37:14 -0400
Received: from [216.32.180.11] ([216.32.180.11]:43627 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbaCUFhL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 01:37:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(zzc89bhzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kz4ejz1de098h1de097hz2dh2a8h4a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
Message-ID: <532BCFCC.4080205@freescale.com>
Date: Fri, 21 Mar 2014 13:36:12 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <y@karo-electronics.de>
CC: Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@karo-electronics.de>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] mtd: gpmi: make blockmark swapping optional
References: <1395235406-13449-1-git-send-email-y>
In-Reply-To: <1395235406-13449-1-git-send-email-y>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014年03月19日 21:23, y@karo-electronics.de 写道:
> +	/* Set up swap_block_mark, must be set before the gpmi_set_geometry() */
> +	if (!of_property_read_bool(this->dev->of_node, "fsl,no-blockmark-swap"))
> +		this->swap_block_mark = !GPMI_IS_MX23(this);


Our ROM guy had confirmed that the Rom will disable the swapping if we 
set the DISBBM bit.
But please do not change any logic for imx23/imx28.

I really do not know what's the benefit we can get from this patch.
Please send the new version about this patch if you want this feature.


thanks
Huang Shijie

