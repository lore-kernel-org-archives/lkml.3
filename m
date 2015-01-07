Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbbAGJBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:01:19 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:59026 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbbAGJBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:01:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Olliver Schinagl <oliver+list@schinagl.nl>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Olliver Schinagl <oliver@schinagl.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rob Herring <robh+dt@kernel.org>, dev@linux-sunxi.org,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v1] ARM:sunxi:sid: Make use of the of_match_ptr
Date: Wed, 07 Jan 2015 10:00:55 +0100
Message-ID: <12820267.9PZueKuf7O@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420616468-3782-1-git-send-email-oliver+list@schinagl.nl>
References: <1420616468-3782-1-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:9rbCm1T5iXrIAYVptkGp6JF1Dzu6DVmbKLtPtEpvsjWGnereOXv
 AwbQNQB1y6/uWJUpcaGUwrfYxXJUChWLBVJ83iLcuEMDWYkei6XtTisbjmm7AKbQ2yFsNSI
 gO8LwRM2byl6M7+02nkyvWOnfnO2rW/UtrL4VXAMblVyTU/JZv1pT8FT7jxGdOvdWJwOlVT
 C1kLzHO38roElk7G2oGYA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2015 08:41:08 Olliver Schinagl wrote:
> From: Olliver Schinagl <oliver@schinagl.nl>
> 
> I probably have forgotten to use this macro for the of_match pointer, so
> this patch adds the of_match_ptr macro.
> 
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
> ---
>  drivers/misc/eeprom/sunxi_sid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/eeprom/sunxi_sid.c b/drivers/misc/eeprom/sunxi_sid.c
> index 8385177..5a330d9 100644
> --- a/drivers/misc/eeprom/sunxi_sid.c
> +++ b/drivers/misc/eeprom/sunxi_sid.c
> @@ -25,6 +25,7 @@
>  #include <linux/kernel.h>
>  #include <linux/kobject.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
>  #include <linux/random.h>
> @@ -146,7 +147,7 @@ static struct platform_driver sunxi_sid_driver = {
>         .remove = sunxi_sid_remove,
>         .driver = {
>                 .name = DRV_NAME,
> -               .of_match_table = sunxi_sid_of_match,
> +               .of_match_table = of_match_ptr(sunxi_sid_of_match),
>         },
>  };
>  module_platform_driver(sunxi_sid_driver);

This looks wrong: sunxi_sid_of_match is defined unconditionally, so
now you get a compiler warning if CONFIG_OF is disabled.

The existing code is good, we only add the of_match_ptr() for drivers
that are useful without CONFIG_OF and that want to save a few bytes
in .data size.

	Arnd
