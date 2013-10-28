Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab3J1XUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 19:20:47 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51046 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab3J1XUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:20:45 -0400
Message-ID: <526EF149.8060304@gmail.com>
Date: Mon, 28 Oct 2013 18:20:41 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <cjb@laptop.org>, Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] mmc: arasan: Add driver for Arasan SDHCI
References: <1381864085-8806-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1381864085-8806-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 02:08 PM, Soren Brinkmann wrote:
> Add a driver for Arasan's SDHCI controller core.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  .../devicetree/bindings/mmc/arasan,sdhci.txt       |  23 +++
>  MAINTAINERS                                        |   1 +
>  drivers/mmc/host/Kconfig                           |  12 ++
>  drivers/mmc/host/Makefile                          |   1 +
>  drivers/mmc/host/sdhci-of-arasan.c                 | 224 +++++++++++++++++++++
>  5 files changed, 261 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mmc/arasan,sdhci.txt
>  create mode 100644 drivers/mmc/host/sdhci-of-arasan.c
> 
> diff --git a/Documentation/devicetree/bindings/mmc/arasan,sdhci.txt b/Documentation/devicetree/bindings/mmc/arasan,sdhci.txt
> new file mode 100644
> index 000000000000..20f0fc25e270
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/arasan,sdhci.txt
> @@ -0,0 +1,23 @@
> +Device Tree Bindings for the Arasan SDCHI Controller
> +
> +  The bindings follow the mmc[1] and the clock bindings[2]. Only deviations are
> +  documented here.
> +
> +  [1] Documentation/devicetree/bindings/mmc/mmc.txt
> +  [2] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +Required Properties:
> +  - compatible: Compatibility string. Must be 'arasan,sdhci'

This string is a bit non-specific. Vendor IP typically has configurable
options, different revs of IP with fixes/differences, and the
possibility of integration wierdness or bugs. So it is better to be as
specific as possible in case the kernel needs to know exactly what
version of h/w this is.

Rob

