Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaIJDVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:21:47 -0400
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:30697
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751576AbaIJDVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:21:46 -0400
Date: Wed, 10 Sep 2014 11:21:30 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Robin Gong <b38343@freescale.com>
CC: <kernel@pengutronix.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Frank.Li@freescale.com>
Subject: Re: [PATCH v1] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
Message-ID: <20140910032128.GD18566@dragon>
References: <1410312816-32171-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410312816-32171-1-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(24454002)(189002)(51704005)(199003)(46102001)(50986999)(104016003)(76176999)(575784001)(21056001)(54356999)(79102001)(99396002)(64706001)(81342001)(106466001)(33656002)(57986006)(110136001)(107046002)(81542001)(26826002)(31966008)(95666004)(86362001)(90102001)(19580405001)(6806004)(77982001)(20776003)(46406003)(74662001)(83322001)(33716001)(50466002)(83506001)(87936001)(83072002)(92566001)(97756001)(80022001)(85852003)(47776003)(97736003)(102836001)(76482001)(23726002)(44976005)(105606002)(85306004)(68736004)(74502001)(4396001)(84676001)(92726001)(19580395003)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB489;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:33:36AM +0800, Robin Gong wrote:
> There is one weird data in rxfifo after one full rx/tx transfer
> done sometimes. It looks a design issue and hard to workaround
> totally, so disable dma functhion here. And will re-enable it
> once the root cause found.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  arch/arm/boot/dts/imx6dl.dtsi | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/imx6dl.dtsi b/arch/arm/boot/dts/imx6dl.dtsi
> index b453e0e..e84a1ff 100644
> --- a/arch/arm/boot/dts/imx6dl.dtsi
> +++ b/arch/arm/boot/dts/imx6dl.dtsi
> @@ -102,6 +102,22 @@
>  	};
>  };
>  
> +&ecspi1 {
> +	dma-names = "", "";
> +};
> +
> +&ecspi2 {
> +	dma-names = "", "";
> +};
> +
> +&ecspi3 {
> +	dma-names = "", "";
> +};
> +
> +&ecspi4 {
> +	dma-names = "", "";
> +};
> +

This looks odd.  Can we drop the dma properties from imx6qdl.dtsi,
and only add them in imx6q.dtsi instead?

Shawn

>  &hdmi {
>  	compatible = "fsl,imx6dl-hdmi";
>  };
> -- 
> 1.9.1
> 
