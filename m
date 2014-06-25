Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbaFYSGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:06:34 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:63664 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbaFYSGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:06:31 -0400
MIME-Version: 1.0
In-Reply-To: <1403202040-12641-5-git-send-email-javier.martinez@collabora.co.uk>
References: <1403202040-12641-1-git-send-email-javier.martinez@collabora.co.uk>
	<1403202040-12641-5-git-send-email-javier.martinez@collabora.co.uk>
Date: Wed, 25 Jun 2014 11:06:30 -0700
X-Google-Sender-Auth: uiM-gjW429JNi1BHmogqrhYv5j8
Message-ID: <CAD=FV=VezCMpYiD6vj_SkPYVM30GWF_YiRZVGyLHDD0-EbD+7Q@mail.gmail.com>
Subject: Re: [PATCH v3 04/14] clk: max77686: Improve Maxim 77686 PMIC clocks binding
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Thu, Jun 19, 2014 at 11:20 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> @@ -33,6 +38,6 @@ Example: Clock consumer node
>         foo@0 {
>                 compatible = "bar,foo";
>                 /* ... */
> -               clock-names = "my-clock";
> -               clocks = <&max77686 2>;
> +               clock-names = "32khz_pmic";
> +               clocks = <&max77686 MAX77686_CLK_PMIC>;

A minor comment here is that you probably shouldn't change "clock-names".

The "clock-names" is the consumer's concept of the clock name and not
the producer's concept.  If this clock were specified as going into
the TPM, for instance, the TPM might call it "32k-reference".  Then
the TPM would get the clock by referring to this name in its driver.

-Doug
