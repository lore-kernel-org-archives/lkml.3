Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3ITR7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:59:13 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:55720 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab3ITR7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:59:01 -0400
MIME-Version: 1.0
In-Reply-To: <1378294169-22661-6-git-send-email-acourbot@nvidia.com>
References: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
	<1378294169-22661-6-git-send-email-acourbot@nvidia.com>
Date: Fri, 20 Sep 2013 19:59:00 +0200
Message-ID: <CACRpkdbB29rL_kTqKQ6ZC=J=p9amRODRDVFMP6ZoF=aa6k9pqA@mail.gmail.com>
Subject: Re: [RFC 5/5] gpiolib: update documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 1:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> +The GPIO framework has quite a bit of history behind it. Currently there exist
> +two different (although very similar) ways of using GPIOs:
> +
> +  - The legacy integer-based interface represents GPIOs as integers. This is
> +    the "historic" way of accessing GPIOs and it was done so because it makes
> +    GPIOs easy to represent and also allows for the compiler to statically know
> +    the GPIO number and use fast-paths on GPIOs for which performance matters.
> +    However, GPIOs can easily be forged this way, and the maximum number of
> +    GPIOs in the system must be known in advance. Functions of this interface
> +    are prefixed with "gpio_".
> +
> +  - The new descriptor-based interface represents GPIOs as an opaque pointer.
> +    This ensures GPIOs are properly acquired before usage, and also does not
> +    presume anything about their underlying implementation. This interface
> +    provides get/put functions to acquire GPIOs according to their function for
> +    a particular device, similarly to e.g. the regulator framework. For these
> +    reasons, it is the preferred way to access GPIOs. Its functions are prefixed
> +    with "gpiod_".

I would put all the new style gpiod_* based things on top of the file, and
all the old stuff under a separate heading below DEPRECATED LEGACY INTERFACE
so it's crystal clear that this is going away.

Yours,
Linus Walleij
