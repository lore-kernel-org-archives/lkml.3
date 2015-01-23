Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbbAWXDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:03:43 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:60312 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbbAWXDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:03:39 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:d966:4ba0:21e9:c020]
In-Reply-To: <1421751268-21401-1-git-send-email-nicolas.ferre@atmel.com>
References: <1421745792.9655.98.camel@x220>
	<1421751268-21401-1-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 23 Jan 2015 15:03:39 -0800
Message-ID: <CAOesGMjwm=e+GSiPcr-7hAf8uNOP9qdCoWjd7aLEny2=tK9vbg@mail.gmail.com>
Subject: Re: [PATCH] ARM: at91: fix Kconfig.debug by adding DEBUG_AT91_UART option
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On Tue, Jan 20, 2015 at 2:54 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> The DEBUG_AT91_UART Kconfig option was forgotten when moving the
> AT91 debug-macro.S file. Add it and use it for the at91.S compilation.
>
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Hi Alexandre,
> Please tell me if this patch makes sense to fix the lack of this
> DEBUG_AT91_UART Kconfig option.
>
> Paul,
> Thanks for the heads up.
>
> Bye,
>   Nico.
>
>  arch/arm/Kconfig.debug | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index e34d24949c6a..b3d388e5f4ff 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -1164,12 +1164,15 @@ config DEBUG_STI_UART
>         bool
>         depends on ARCH_STI
>
> +config DEBUG_AT91_UART
> +       bool
> +       depends on ARCH_AT91
> +

This is not inserted in the list alphabetically. It's not very well
sorted today either, but it should probably go above exynos.

Also, there are a number of configs that _select_ DEBUG_AT91_UART in
the list above, but they don't depend on AT91. So what can happen is
that you can select those, and then they will enable this option
(which will spit out a warning about unfulfilled dependency).

You should probably make the choices that select this option also
depend on AT91?


-Olof
