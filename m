Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbaHHMxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:53:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61759 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaHHMxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <1406126699-10053-1-git-send-email-grygorii.strashko@ti.com>
References: <1406126699-10053-1-git-send-email-grygorii.strashko@ti.com>
Date: Fri, 8 Aug 2014 14:53:50 +0200
Message-ID: <CACRpkdZAHj+PMu-xJJow+9ndbp9srnQtmb4E2k5x3nkaQA1jCg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: keystone: add dsp gpio controller driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        ivan.khoronzhuk@ti.com, Muralidharan Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 4:44 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> From: Murali Karicheri <m-karicheri2@ti.com>
>
> On Keystone SOCs, ARM host can send interrupts to DSP cores using the
> DSP GPIO controller IP. Each DSP GPIO controller provides 28 IRQ signals for
> each DSP core. This is one of the component used by the IPC mechanism used
> on Keystone SOCs.
>
> Keystone 2 DSP GPIO controller has specific features:
> - each GPIO can be configured only as output pin;
> - setting GPIO value to 1 causes IRQ generation on target DSP core;
> - reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
>   pending.
>
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> Changes in v2:
> - minor comments applied

Hm so there was one major comment, quoting myself:

"And if you proceed with this, please integrate it with
drivers/gpio/gpio-syscon.c, I don't need more special
syscons GPIO handlers."

Maybe you missed this in the midst of the other discussions
about whether this is GPIO at all, but that comment still
stands even if you talk me down on the generality of this
driver.

> +++ b/Documentation/devicetree/bindings/gpio/gpio-keystone.txt

Make this follow the style in:
Documentation/devicetree/bindings/gpio/cirrus,clps711x-mctrl-gpio.txt

Yours,
Linus Walleij
