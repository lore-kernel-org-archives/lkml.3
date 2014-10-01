Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaJAMLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:11:17 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:64765 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaJAMLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:11:15 -0400
MIME-Version: 1.0
In-Reply-To: <1410854903-26419-3-git-send-email-d.lavnikevich@sam-solutions.com>
References: <1410537872-17274-1-git-send-email-d.lavnikevich@sam-solutions.com>
	<1410854903-26419-1-git-send-email-d.lavnikevich@sam-solutions.com>
	<1410854903-26419-3-git-send-email-d.lavnikevich@sam-solutions.com>
Date: Wed, 1 Oct 2014 09:11:13 -0300
Message-ID: <CAOMZO5CgrQ6Wf6kStga40TUKx9dARygCNB4OYSUoG3c8eUYbrA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ARM: dts: pbab01: enable I2S audio on
 phyFLEX-i.MX6 boards
From: Fabio Estevam <festevam@gmail.com>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, perex@perex.cz,
        Takashi Iwai <tiwai@suse.de>, =devicetree@vger.kernel.org,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 5:08 AM, Dmitry Lavnikevich
<d.lavnikevich@sam-solutions.com> wrote:

> +       regulators {
> +               sound_1v8: regulator@2 {

We usually start counting from @0.

> +                       compatible = "regulator-fixed";
> +                       reg = <2>;
> +                       regulator-name = "i2s-audio-1v8";
> +                       regulator-min-microvolt = <1800000>;
> +                       regulator-max-microvolt = <1800000>;
> +                       regulator-always-on;

No need to have this 'regulator-always-on'

> +               };
> +
> +               sound_3v3: regulator@3 {

,so this one should be @1.

> +                       compatible = "regulator-fixed";
> +                       reg = <3>;
> +                       regulator-name = "i2s-audio-3v3";
> +                       regulator-min-microvolt = <3300000>;
> +                       regulator-max-microvolt = <3300000>;
> +                       regulator-always-on;

No need to have this 'regulator-always-on'

> +&ssi2 {
> +       fsl,mode = "i2s-slave";

Please remove this 'fsl,mode' property. It is ignored by the fsl_ssi driver.
