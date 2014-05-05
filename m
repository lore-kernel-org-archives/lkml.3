Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbaEEUhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:37:25 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:56665 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaEEUhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:37:21 -0400
MIME-Version: 1.0
In-Reply-To: <1398904476-26200-9-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
	<1398904476-26200-9-git-send-email-s-anna@ti.com>
Date: Mon, 5 May 2014 15:37:20 -0500
Message-ID: <CAL_JsqJW1pqUjQ3DQrppO5n=MmpFOhCyU2zkSzA9s9TpYbq3CA@mail.gmail.com>
Subject: Re: [PATCHv5 RFC 08/15] hwspinlock/core: add support for base id in DT
From: Rob Herring <robherring2@gmail.com>
To: Suman Anna <s-anna@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 7:34 PM, Suman Anna <s-anna@ti.com> wrote:
> The HwSpinlock core requires a base id for registering a bank
> of hwspinlocks. This base id needs to be unique across multiple
> IP instances of a hwspinlock device, so that each hwlock can be
> represented uniquely in a system.
>
> Support has been added to represent this in DT through a common
> property 'hwlock-base-id', and retrieve the value through a core
> OF helper function, of_hwspin_lock_get_base_id(). The representation
> in DT provides a uniform way of assigning a fixed base value for a
> hwspinlock device across different SoCs.
>
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
>  Documentation/devicetree/bindings/hwlock/hwlock.txt |  6 ++++++
>  drivers/hwspinlock/hwspinlock_core.c                | 21 +++++++++++++++++++++
>  include/linux/hwspinlock.h                          |  1 +
>  3 files changed, 28 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/hwlock/hwlock.txt b/Documentation/devicetree/bindings/hwlock/hwlock.txt
> index 32381cc..d538a9b 100644
> --- a/Documentation/devicetree/bindings/hwlock/hwlock.txt
> +++ b/Documentation/devicetree/bindings/hwlock/hwlock.txt
> @@ -18,6 +18,12 @@ Common properties:
>                         property is needed on hwlock devices, where the number
>                         of supported locks within a hwlock device cannot be
>                         read from a register.
> +- hwlock-base-id:      An unique base Id for the locks for a particular hwlock
> +                       device. This property is mandatory ONLY if a SoC has
> +                       several hwlock devices.
> +
> +                       See documentation on struct hwspinlock_pdata in
> +                       include/linux/hwspinlock.h for more details.

The documentation cannot refer to kernel files. Generally, creating a
global number space like this would not be accepted, but I don't
really have any better idea here.

Please put all binding docs in 1 patch and copy all the DT binding maintainers.

Rob
