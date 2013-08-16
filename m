Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3HPWVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:21:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41905 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab3HPWVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:21:16 -0400
Message-ID: <520EA5D6.3040409@wwwdotorg.org>
Date: Fri, 16 Aug 2013 16:21:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: bcousson@baylibre.com, tony@atomide.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ian.campbell@citrix.com, rob@landley.net,
        george.cherian@ti.com, gregkh@linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH v2] extcon: palmas: Modified the compatible type to *ti,palmas-usb-vid*
References: <1376648448-27447-1-git-send-email-kishon@ti.com>
In-Reply-To: <1376648448-27447-1-git-send-email-kishon@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 04:20 AM, Kishon Vijay Abraham I wrote:
> The Palmas device contains only a USB VID detector, so modified the
> compatible type to *ti,palmas-usb-vid*.

> diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt

>  PALMAS USB COMPARATOR
>  Required Properties:
> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
> + - compatible : Should be "ti,palmas-usb-vid".

Has the old value been published in a release kernel? If so, it makes
sense to document both values, but say the old one is deprecated, and ...

> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c

>  static struct of_device_id of_palmas_match_tbl[] = {
> -	{ .compatible = "ti,palmas-usb", },
> -	{ .compatible = "ti,twl6035-usb", },
> +	{ .compatible = "ti,palmas-usb-vid", },

... perhaps just add the new value here, and don't remove the old values?

If not, ignore this.

