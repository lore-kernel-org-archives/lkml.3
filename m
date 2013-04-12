Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3DLWak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:30:40 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41078 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3DLWaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:30:39 -0400
MIME-Version: 1.0
In-Reply-To: <201304121314.r3CDEJxs011832@latitude>
References: <201304121314.r3CDEJxs011832@latitude>
Date: Sat, 13 Apr 2013 00:30:39 +0200
Message-ID: <CACRpkdZB5t_dQYSXScx+-zbNePe2wiJhBkYJaeK=GJSMN-dpNQ@mail.gmail.com>
Subject: Re: [NEW DRIVER V4 5/7] DA9058 GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 3:05 PM, Anthony Olech
<anthony.olech.opensource@diasemi.com> wrote:

> This is the GPIO component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC driver.
> It depends on the CORE component driver of the DA9058 MFD.
> The meaning of the PMIC register 21 bits 1 and 5 has been documented
> in the driver source.
>
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>

Looks OK to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

> +       /*
> +        * INP configured pins:
> +        *     9 == DebounceOn+ActiceLowPullUp
> +        *
> +        * OUT configured pins:
> +        *     7 == PushPull+ExternalPullUpToVDDIO
> +        *     3 == PushPull+InternalPullUpToVDDIO
> +        *     2 == OpenDrain+InternalPullUpToVDDIO
> +        */
> +
> +       gpio->inp_config = 0x99;
> +       gpio->out_config = 0x77;

Looks pretty hardcoded, and should be - if you want to make this
runtime or DT/platforms configurable you need to migrate the driver
to pinctrl, which is the place where we do things like this.

Yours,
Linus Walleij
