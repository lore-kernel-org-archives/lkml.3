Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3FGNAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:00:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62661 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3FGNAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:00:39 -0400
MIME-Version: 1.0
In-Reply-To: <1370606855-19403-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1370606855-19403-1-git-send-email-patrice.chotard.st@gmail.com>
Date: Fri, 7 Jun 2013 15:00:38 +0200
Message-ID: <CACRpkdbixv21db-_TcPApRj7=BHCQ52TDXnHqMpn+kaXcBBrhA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-abx500: Add device tree support
From: Linus Walleij <linus.walleij@linaro.org>
To: Patrice Chotard <patrice.chotard.st@gmail.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 2:07 PM,  <patrice.chotard.st@gmail.com> wrote:

> From: Patrice Chotard <patrice.chotard@st.com>
>
> We use the same way to define pin muxing and pin
> configuration than for nomadik. So pickup code
> from pinctrl_nomadik.c to be able to implement
> pin multiplexing and pin configuration using
> the device tree.
>
> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@st.com>
> Signed-off-by: Patrice Chotard <patrice.chotard@st.com>

Overall this is looking fine.

> +- ste,config: Handle of pin configuration node (e.g. ste,config = <&slpm_in_wkup_pdis>)
> +
> +- ste,input : <0/1/2>
> +       0: input with no pull
> +       1: input with pull up,
> +       2: input with pull down,
> +
> +- ste,output: <0/1/2>
> +       0: output low,
> +       1: output high,
> +       2: output (value is not specified).

As I have just discussed with Heiko, we need generic pin config bindings for
the drivers using generic pin config, such as the abx500. We have to start
unifying unifiable stuff...

i.e. this is not similar to the Nomadik pinctrl driver, because that one is not
using generic pin config.

So we're trying to agree on generic bindings with generic parsing code to
avoid code duplication.

Please check my review of Heiko's patch for my ideas and comment in
that thread.

Subject:
"[PATCH v2 5/8] pinctrl: add pinctrl driver for Rockchip SoCs"

Yours,
Linus Walleij
