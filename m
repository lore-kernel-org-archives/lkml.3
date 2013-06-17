Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3FQFoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:44:38 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:49185 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3FQFoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:44:37 -0400
MIME-Version: 1.0
In-Reply-To: <d678410ae1b6ff11a221a996f5aa4b4ee4ed01a5.1370262666.git.michal.simek@xilinx.com>
References: <d96317c2681b5feb9e058efe0bd60ff101a0e0fa.1370262666.git.michal.simek@xilinx.com>
	<d678410ae1b6ff11a221a996f5aa4b4ee4ed01a5.1370262666.git.michal.simek@xilinx.com>
Date: Mon, 17 Jun 2013 07:44:37 +0200
Message-ID: <CACRpkdaDO7QZZB28ugUY7XqgrhHPj8UrxdOsFuSdFt4RCVz2Ng@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] GPIO: xilinx: Add support for dual channel
From: Linus Walleij <linus.walleij@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 2:31 PM, Michal Simek <michal.simek@xilinx.com> wrote:

> Supporting the second channel in the driver.
> Offset is 0x8 and both channnels share the same
> IRQ.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>
> ---
> Changes in v2:
> - Use kernel doc format - suggested by Linus Walleij
> - Do not use __raw_readl/__raw_writel IO in this patch
> - Use of_property_read_u32 helper function
> - Use BIT()
> - Change patch subject

Patch is looking overall nice and improves the kernel so
applied.

But check this:

> @@ -202,6 +230,57 @@ static int xgpio_of_probe(struct device_node *np)
>                        np->full_name, status);
>                 return status;
>         }
> +
> +       pr_info("XGpio: %s: registered, base is %d\n", np->full_name,
> +                                                       chip->mmchip.gc.base);
> +
> +       tree_info = of_get_property(np, "xlnx,is-dual", NULL);
> +       if (tree_info && be32_to_cpup(tree_info)) {

Doesn't this work:

if (of_property_read_bool(np, "xlnx,is-dual")) {
(...)

?

Yours,
Linus Walleij
