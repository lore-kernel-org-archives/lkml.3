Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaELJ3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:29:14 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36489 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaELJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140511212514.GV7047@lukather>
References: <1399621082-10712-1-git-send-email-linus.walleij@linaro.org>
	<20140511212514.GV7047@lukather>
Date: Mon, 12 May 2014 11:29:11 +0200
Message-ID: <CACRpkdZip4S7ySAVA4xtXxU-Y5DeXfVjK67aJOe_RiXG7iT15g@mail.gmail.com>
Subject: Re: [PATCH] RFT: pinctrl: sunxi: convert to GPIO irqchip helpers
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 11:25 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> What I did so far is having a single domain, with the same handler
> registered for all the interrupts, and the various interrupts from the
> various banks just being at a different offsets in the domain.
>
> Basically, something like that:
> http://code.bulix.org/ym3zuv-86191
>
> Do you know if it would be possible to use the generic gpiolib
> behaviour in such a case?

Basically the helpers are for the simple case where every pin
can fire an independent interrupt.

Since there is just one single irqdomain for the entire chip, the
helpers require that all mappings go through the same domain.

If having several domains or other split-up results in more
elegant code, then code another solution locally, because we
just want to cover the generic cases, the special cases will still
be special.

Unless you see some really elegant way forward of course...
always choose the most elegand refactoring if you can.

Yours,
Linus Walleij
