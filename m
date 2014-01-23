Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaAWH3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:29:14 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46019 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaAWH3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:29:07 -0500
MIME-Version: 1.0
In-Reply-To: <1389886651-31990-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389886545-31498-1-git-send-email-srinivas.kandagatla@st.com>
	<1389886651-31990-1-git-send-email-srinivas.kandagatla@st.com>
Date: Thu, 23 Jan 2014 08:29:06 +0100
Message-ID: <CACRpkdaBAnpfHBqkgU2emZrYwHGh9KvDvqfnCvaWdU5jYgxStA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] pinctrl: st: Add software edge trigger interrupt support.
From: Linus Walleij <linus.walleij@linaro.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 4:37 PM,  <srinivas.kandagatla@st.com> wrote:

> ST pin controller does not have hardware support for detecting edge
> triggered interrupts, It only has level triggering support.
> This patch attempts to fake up edge triggers from hw level trigger
> support in software.

(...)


> +/*
> + * Edge triggers are not supported at hardware level, it is supported by
> + * software by exploiting the level trigger support in hardware.
> + * Software uses a virtual register (EDGE_CONF) for edge trigger configuration
> + * of each gpio pin in a GPIO bank.

(...)

> +/*
> + * As edge triggers are not supported at hardware level, it is supported by
> + * software by exploiting the level trigger support in hardware.

(...)

All this is quite hard to understand. Maybe it's just because
it's hard overall. Edge triggers are not supported by hardware
so we use the hardware edge trigger support?

That is a bit oxymoronic...

> + * Steps for detection raising edge interrupt in software.
> + *
> + * Step 1: CONFIGURE pin to detect level LOW interrupts.
> + *
> + * Step 2: DETECT level LOW interrupt and in irqmux/gpio bank interrupt handler,
> + * if the value of pin is low, then CONFIGURE pin for level HIGH interrupt.
> + * IGNORE calling the actual interrupt handler for the pin at this stage.
> + *
> + * Step 3: DETECT level HIGH interrupt and in irqmux/gpio-bank interrupt handler
> + * if the value of pin is HIGH, CONFIGURE pin for level LOW interrupt and then
> + * DISPATCH the interrupt to the interrupt handler of the pin.

But I do understand this, that's VERY clever and may be something
that can be exploited on other hardware as well some day.

So patch applied.

Yours,
Linus Walleij
