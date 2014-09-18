Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbaIRORX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:17:23 -0400
Received: from mail-bn1bon0118.outbound.protection.outlook.com ([157.56.111.118]:22624
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755799AbaIRORV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:17:21 -0400
Date: Thu, 18 Sep 2014 22:17:06 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
CC: <stefan@agner.ch>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: dts: vf610-colibri: Add backlight support
Message-ID: <20140918141705.GM4796@dragon>
References: <cover.1410930820.git.bhuvanchandra.dv@toradex.com>
 <cea494421deefe0b862e31b08685074715acf8d6.1410930820.git.bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cea494421deefe0b862e31b08685074715acf8d6.1410930820.git.bhuvanchandra.dv@toradex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(24454002)(199003)(189002)(54356999)(85852003)(102836001)(90102001)(44976005)(81342003)(76482002)(4396001)(84676001)(19580395003)(106466001)(19580405001)(46102003)(74662003)(68736004)(97756001)(47776003)(92726001)(6806004)(83506001)(87936001)(46406003)(85306004)(31966008)(23726002)(80022003)(74502003)(81542003)(50986999)(105606002)(64706001)(26826002)(33656002)(110136001)(86362001)(99396002)(107046002)(76176999)(95666004)(33716001)(83072002)(79102003)(104016003)(83322001)(50466002)(21056001)(97736003)(92566001)(20776003)(77982003)(57986006);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0628;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 01:46:30PM +0530, Bhuvanchandra DV wrote:
> 
> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
> ---
>  arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    6 ++++++
>  arch/arm/boot/dts/vf610-colibri.dtsi        |    7 +++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> index ba98039..f1988a0 100644
> --- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> +++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
> @@ -52,3 +52,9 @@
>  &pwm1 {
>  	status = "okay";
>  };
> +
> +&backlight {
> +	brightness-levels = <0 4 8 16 32 64 128 255>;
> +	default-brightness-level = <6>;
> +	status  = "okay";
> +};
> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi b/arch/arm/boot/dts/vf610-colibri.dtsi
> index 9bd1415..e725306 100644
> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
> @@ -25,6 +25,13 @@
>  		};
>  	};
>  
> +	backlight: bl {

I would suggest we name the node following the example in
Documentation/devicetree/bindings/pwm/pwm.txt, i.e. bl: backlight.

> +		compitable = "pwm-backlight";
> +		pwms = <&pwm0 0 5000000 0>;
> +		pwm-names = " backlight";

Drop the leading space in the string.

Shawn

> +		status = "disabled";
> +	};
> +
>  };
>  
>  &esdhc1 {
> -- 
> 1.7.9.5
> 
