Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995AbaFQQ6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:58:19 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:41429 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704AbaFQQ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <1401198917-16077-1-git-send-email-p.zabel@pengutronix.de>
References: <1401198917-16077-1-git-send-email-p.zabel@pengutronix.de>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 17 Jun 2014 11:57:55 -0500
Message-ID: <CAL_JsqLjyNQfjs4cDf8Eh1WeVGauym=qbF_pEAMu7ASVMqaccg@mail.gmail.com>
Subject: Re: [RFC PATCH] mfd: syscon: add child device support
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 8:55 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> For devices which have a complete register for themselves, it is possible to
> place them next to the syscon device with overlapping reg ranges. The same is

We want to avoid overlapping ranges.

> not possible for devices which only occupy bitfields in registers shared with
> other users.

You are addressing the latter case here?

> For devices that are completely controlled by bitfields in the syscon address
> range, such as multiplexers or voltage regulators, allow to put child devices
> into the syscon device node.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/mfd/syscon.txt | 11 +++++++++++
>  drivers/mfd/syscon.c                             |  2 ++
>  2 files changed, 13 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
> index fe8150b..a7e11d5 100644
> --- a/Documentation/devicetree/bindings/mfd/syscon.txt
> +++ b/Documentation/devicetree/bindings/mfd/syscon.txt
> @@ -9,10 +9,21 @@ using a specific compatible value), interrogate the node (or associated
>  OS driver) to determine the location of the registers, and access the
>  registers directly.
>
> +Optionally, devices that are only controlled through single syscon
> +registers or bitfields can also be added as child nodes to the syscon
> +device node. These devices can implicitly assume their parent node
> +as syscon provider without referencing it explicitly via phandle.
> +In this case, the syscon node should have #address-cells = <1> and
> +#size-cells = <0> and no ranges property.
> +

I'd like to see an example. What does reg in the child contain? The
register address?

What if the child device needs 3 bitfields from 3 different registers?
It seems to me that you could then want to describe every single
bitfield of a block in the DT. That seems like too much information in
DT much like trying to describe every single clock in DT.

Rob
