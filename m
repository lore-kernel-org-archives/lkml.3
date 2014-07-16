Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbaGPIk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:40:29 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:51260 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbaGPIkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:40:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
Subject: Re: [PATCH v3 08/12] Documentation: bindings: add doc for the USB2 ChipIdea USB driver
Date: Wed, 16 Jul 2014 10:39:36 +0200
Message-ID: <23972141.94aiK9jz66@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405499166-6726-9-git-send-email-antoine.tenart@free-electrons.com>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com> <1405499166-6726-9-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:zBxYZ5VJjfU3NyouqNO80R4W3gq+5vKxGpnQhd3tbWf
 1yWTN0xmwl43N6qPU117Q0QZA4UphS7uCQ9+KPrrIZwndo+iMu
 VMeb2R+rewOk8mK6gX7UxE4q8bPOD02fWEZ6eMGJPJNIfUhRc7
 aXKFcdhBlcxCCqIyKFa/MbnkCl/8f4HWQN0rDcI2FV1h2OUOSG
 XykAsyseoV4pmSECnEX9AAIQ6KKQN3OZsI0S2yJYNxvO9x5Gjr
 7BimWS7B8VhvdgOX4f8kDsxCEyU+ASxfLKKbHdbQg0YlwxBVtc
 10E2JZnFyYVreqQQbHAmHkmQqeJj+fqoEsU72Z+a14pnEcUkWk
 y+EvrG7QEvbbNMzvYmiQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 10:26:02 Antoine Ténart wrote:
> +
> +Required properties:
> +- compatible: should be "chipidea,usb2"
> +- reg: base address and length of the registers
> +- interrupts: interrupt for the USB controller
> +
> +Optional properties:
> +- clocks: reference to the USB clock
> +- usb-phy: reference to the USB PHY

I think the phy reference should use the standard phy binding, using
"phys" property to refer to a node that has a "#phy-cells" property.

It seems the code gets this right, but just the documentation is wrong.

> +- vbus-supply: reference to the VBUS regulator
> +- dma-mask: DMA bit mask

No. Do not use "dma-mask" as a property, that is a pure Linux specific
concept. The DT way to express this is to use the 'dma-ranges' property
in the device's parent to describe any bus-related restrictions, and
for the driver to ask for a mask that matches what the hardware is
capable of (which may be smaller or larger than what the bus supports).

	Arnd
