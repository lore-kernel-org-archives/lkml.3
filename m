Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3HLXKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 19:10:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50332 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3HLXJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 19:09:59 -0400
Message-ID: <52096B42.60500@wwwdotorg.org>
Date: Mon, 12 Aug 2013 17:09:54 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: benoit.cousson@linaro.org, tony@atomide.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, ian.campbell@citrix.com,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH v3] arm: omap5: dts: add palmas-usb node
References: <1373979037-27587-1-git-send-email-balbi@ti.com> <1376302675-15795-1-git-send-email-kishon@ti.com>
In-Reply-To: <1376302675-15795-1-git-send-email-kishon@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 04:17 AM, Kishon Vijay Abraham I wrote:
> From: Felipe Balbi <balbi@ti.com>
> 
> Without this node, there will be no palmas
> driver to notify dwc3 that a cable has
> been connected and, without that, dwc3
> will never initialize.

> diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts

>  		interrupt-controller;
>  		#interrupt-cells = <2>;
>  
> +		extcon_usb3: palmas_usb {
> +			compatible = "ti,palmas-usb";

This isn't so much a comment on this patch as the Palmas binding:

Presumably, the Palmas device contains a USB VID detector, not a whole
USB controller. I'd expect the compatible value to indicate this more
directly, i.e. be something like ti,palmas-usb-vid or
ti,palmas-usb-vid-detector.
