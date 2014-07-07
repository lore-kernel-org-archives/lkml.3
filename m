Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaGGO7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:59:23 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:43464 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaGGO7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:59:20 -0400
MIME-Version: 1.0
In-Reply-To: <1403264094-16140-1-git-send-email-maxime.coquelin@st.com>
References: <1403264094-16140-1-git-send-email-maxime.coquelin@st.com>
Date: Mon, 7 Jul 2014 16:59:19 +0200
Message-ID: <CACRpkdbB5zniNTdUSgMmmqFQwGjHLAF9p601R5A_DkNdz0q01w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: st: Fix irqmux handler
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel@stlinux.com,
        Patrice CHOTARD <patrice.chotard@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 1:34 PM, Maxime COQUELIN <maxime.coquelin@st.com> wrote:

> st_gpio_irqmux_handler() reads the status register to find out
> which banks inside the controller have pending IRQs.
> For each banks having pending IRQs, it calls the corresponding handler.
>
> Problem is that current code restricts the number of possible banks inside the
> controller to ST_GPIO_PINS_PER_BANK. This define represents the number of pins
> inside a bank, so it shouldn't be used here.
>
> On STiH407, PIO_FRONT0 controller has 10 banks, so IRQs pending in the two
> last banks (PIO18 & PIO19) aren't handled.
>
> This patch replace ST_GPIO_PINS_PER_BANK by the number of banks inside the
> controller.
>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: <stable@vger.kernel.org> #v3.15+
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Patch applied for fixes with Srinivas ACK.

Thanks!
Yours,
Linus Walleij
