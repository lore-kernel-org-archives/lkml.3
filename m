Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaAWHW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:22:57 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:33024 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaAWHWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:22:54 -0500
MIME-Version: 1.0
In-Reply-To: <1389886613-31945-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389886545-31498-1-git-send-email-srinivas.kandagatla@st.com>
	<1389886613-31945-1-git-send-email-srinivas.kandagatla@st.com>
Date: Thu, 23 Jan 2014 08:22:53 +0100
Message-ID: <CACRpkdZV7TBP7Ac1MPVSAgJeqWtDQEuT3dHjUJHgDTeX9_datw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] pinctrl: st: Add Interrupt support.
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

On Thu, Jan 16, 2014 at 4:36 PM,  <srinivas.kandagatla@st.com> wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> This patch add interrupt support to the pincontroller driver.
>
> ST Pincontroller GPIO bank can have one of the two possible types of
> interrupt-wirings.
>
> First type is via irqmux, single interrupt is used by multiple gpio
> banks. This reduces number of overall interrupts numbers required. All
> these banks belong to a single pincontroller.
>                   _________
>                  |         |----> [gpio-bank (n)    ]
>                  |         |----> [gpio-bank (n + 1)]
>         [irqN]-- | irq-mux |----> [gpio-bank (n + 2)]
>                  |         |----> [gpio-bank (...  )]
>                  |_________|----> [gpio-bank (n + 7)]
>
> Second type has a dedicated interrupt per gpio bank.
>
>         [irqN]----> [gpio-bank (n)]
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

I've applied this patch so that it won't just sit idle.
Besides you've done a real good job on it Srinivas.

It'll be for v3.15 though and I'm still waiting to see if
the device tree people say something about it.

Yours,
Linus Walleij
