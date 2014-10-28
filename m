Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbaJ1JIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:08:55 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58641 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJ1JIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:08:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] Documentation: gpio: guidelines for bindings
Date: Tue, 28 Oct 2014 10:08:45 +0100
Message-ID: <4048602.9BsHAsA6cq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414470034-16143-1-git-send-email-acourbot@nvidia.com>
References: <1414470034-16143-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bVKzIMyDNYIUm0wIDTMCajza6YZ8GglmG4A/cZwNbqd
 EqFs1V9RtiHHIM2ZnLNdXcX0+wRlN8J9R1VJrjVcTgNhW3tfiC
 HCf3Ixn0L195rlbpdYpv1SzsLP38IVxi0c50KHHtcAgofco3DR
 zRsJkKOnuRhCLcFL/m2c3aTCOj6GeaNFP+KOM2C1GW+yD5HGnk
 CClQC+5TqcO8I4HlBjwyiMVGtbtROKyP0VUrENkMhNW452xKm/
 7MKskpucYzOzw6Z6aQPPtAy1mXZJH4I1Q64P1010aPOgFj7yam
 AV7iPVpf9qt5ZiPqRwjAhA689pb+TCIMCU3ELM8FWc4BvN9Ftd
 mLzO2BxECYXfy3tn6Vlc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 13:20:34 Alexandre Courbot wrote:
> +GPIO properties should be named "[<name>-]gpios", with <name> being the con_id
> +argument that is passed to gpiod_get(). While a NULL con_id is accepted by the
> +GPIO API for compatibility reasons (resolving to the "gpios" property), it is
> +not allowed for new bindings.
> +
> +GPIO properties can contain one or more GPIO phandles, but only in exceptional
> +cases should they contain more than one. If your device uses several GPIOs with
> +distinct functions, reference each of them under its own property, giving it a
> +meaningful name. The only case where an array of GPIOs is accepted is when
> +several GPIOs serve the same function (e.g. a parallel data line). In that case
> +individual GPIOs can be retrieved using gpiod_get_index().
> +
> +The exact meaning of each gpios property must be documented in the device tree
>  binding for each device.

The binding should be written in an OS neutral way, so it would be better to avoid
direct references to Linux APIs in the part that specifies the allowed properties.

Could you reword this so the Linux interfaces are described in an "implementation
notes" section that is separate from the main part?

	Arnd
