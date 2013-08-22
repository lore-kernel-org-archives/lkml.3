Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3HVUua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:50:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47743 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3HVUu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:50:28 -0400
Message-ID: <5216798E.8070900@wwwdotorg.org>
Date: Thu, 22 Aug 2013 14:50:22 -0600
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
Subject: Re: [PATCH v4] extcon: palmas: Added a new compatible type *ti,palmas-usb-vid*
References: <1377160283-26934-1-git-send-email-kishon@ti.com>
In-Reply-To: <1377160283-26934-1-git-send-email-kishon@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 02:31 AM, Kishon Vijay Abraham I wrote:
> The Palmas device contains only a USB VBUS-ID detector, so added a
> compatible type *ti,palmas-usb-vid*. Didn't remove the existing compatible
> types for backward compatibility.

> diff --git a/Documentation/devicetree/bindings/extcon/extcon-palmas.txt b/Documentation/devicetree/bindings/extcon/extcon-palmas.txt

>  PALMAS USB COMPARATOR
>  Required Properties:
> - - compatible : Should be "ti,palmas-usb" or "ti,twl6035-usb"
> + - compatible : Should be "ti,palmas-usb-vid". "ti,twl6035-usb" and
> +   "ti,palmas-usb" is deprecated and is kept for backward compatibility.

So this defines one new value and deprecates the two old values.

Why isn't a new "ti,twl6035-usb-vid" entry useful? Don't you still need
SoC-specific compatible values so the driver can enable any SoC-specific
bug-fixes/workarounds later if needed?
