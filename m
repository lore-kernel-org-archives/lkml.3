Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3H2TV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 15:21:27 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50242 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab3H2TVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 15:21:25 -0400
Message-ID: <521F9F2F.1060307@wwwdotorg.org>
Date: Thu, 29 Aug 2013 13:21:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: balbi@ti.com, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, grant.likely@linaro.org, rob@landley.net,
        ian.campbell@citrix.com, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, bcousson@baylibre.com,
        davidb@codeaurora.org, arnd@arndb.de, swarren@nvidia.com,
        popcornmix@gmail.com
Subject: Re: [PATCH v3 3/3] ARM: dts: dra7-evm: Add extcon nodes for USB ID
 pin detection
References: <1377711185-31238-1-git-send-email-george.cherian@ti.com> <1377711185-31238-4-git-send-email-george.cherian@ti.com>
In-Reply-To: <1377711185-31238-4-git-send-email-george.cherian@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 11:33 AM, George Cherian wrote:
> Add
> 	-extcon nodes for USB ID pin detection.
> 	-i2c nodes.
> 	-pcf nodes to which USB ID pin is connected.

> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts

>  &dwc3_1 {
> -	dr_mode = "otg";
> +	dr_mode = "host";
>  };

I wonder why one cares about ID/VBUS detection if the port doesn't
operate in OTG mode?

>  &dwc3_2 {
>  	dr_mode = "host";
>  };
> +
> +&usb1 {
> +	extcon = <&extcon1>;
> +};
> +
> +&usb2 {
> +	extcon = <&extcon2>;
> +};

I assume the "extcon" property is already fully documented in the
binding for the USB controller? For some reason, "extcon" looks like an
odd property name; I would have expected something more HW-oriented that
Linux-subsystem-oriented, such as "connector", or "usb-connector".

