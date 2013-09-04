Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362Ab3IDILD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:11:03 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:37090 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934319Ab3IDIK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:10:59 -0400
Message-ID: <5226EAD5.8070400@mm-sol.com>
Date: Wed, 04 Sep 2013 11:09:57 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Suman Anna <s-anna@ti.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] hwspinlock/omap: add support for dt nodes
References: <1378230767-54931-1-git-send-email-s-anna@ti.com>
In-Reply-To: <1378230767-54931-1-git-send-email-s-anna@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

Thanks for the patch.

On 09/03/2013 08:52 PM, Suman Anna wrote:
> HwSpinlock IP is present only on OMAP4 and other newer SoCs,
> which are all device-tree boot only. This patch adds the
> base support for parsing the DT nodes, and removes the code
> dealing with the traditional platform device instantiation.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
>  .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 28 ++++++++++
>  arch/arm/mach-omap2/Makefile                       |  3 --
>  arch/arm/mach-omap2/hwspinlock.c                   | 60 ----------------------
>  drivers/hwspinlock/omap_hwspinlock.c               | 21 ++++++--
>  4 files changed, 45 insertions(+), 67 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>  delete mode 100644 arch/arm/mach-omap2/hwspinlock.c
> 
> diff --git a/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> new file mode 100644
> index 0000000..adfb8ad
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
> @@ -0,0 +1,28 @@
> +OMAP4+ HwSpinlock Driver
> +
> +Required properties:
> +- compatible:		Currently supports only "ti,omap4-hwspinlock" for
> +				OMAP44xx, OMAP54xx, AM33xx, AM43xx, DRA7xx SoCs
> +- reg:			Contains the hwspinlock register address range (base
> +			address and length)
> +- ti,hwmods:		Name of the hwmod associated with the hwspinlock device
> +
> +Optional properties:
> +- base_id:		Base Id for the locks for a particular hwspinlock

Could you rename base_id to base-id. The property name convention is to
use dashes in DT world.

regards,
Stan


