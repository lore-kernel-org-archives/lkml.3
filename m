Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaHAUYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:24:20 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58657 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaHAUYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:24:15 -0400
MIME-Version: 1.0
In-Reply-To: <1406868897-26874-4-git-send-email-afaerber@suse.de>
References: <1406868897-26874-1-git-send-email-afaerber@suse.de>
	<1406868897-26874-4-git-send-email-afaerber@suse.de>
Date: Fri, 1 Aug 2014 13:24:12 -0700
X-Google-Sender-Auth: ewKxyLL1pDtE-ckolQs0MhkbdvM
Message-ID: <CAD=FV=W2XJzv4NpB=27AFjX94VkH8dYXxAPBL58ntXL2WvRCoQ@mail.gmail.com>
Subject: Re: [PATCH v5 03/10] ARM: dts: Clean up exynos5250-snow
From: Doug Anderson <dianders@chromium.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

On Thu, Jul 31, 2014 at 9:54 PM, Andreas Färber <afaerber@suse.de> wrote:
> Use the new style of referencing inherited nodes and use symbolic names.
> Reorder one pinctrl node in GPIO order.
>
> Goal is the alignment of all exynos5250 based device trees for comparison.
>
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v4 -> v5:
>  * Introduced labels to consistently use new referencing style (Tomasz)
>  * Use IRQ_TYPE_* constants
>  * Use some more GPIO_ACTIVE_*
>
>  v3 -> v4: Unchanged
>
>  v3: New (Doug Anderson)
>
>  arch/arm/boot/dts/exynos5250-snow.dts | 291 +++++++++++++++++-----------------
>  arch/arm/boot/dts/exynos5250.dtsi     |  20 +--

As much as possible it's nice to touch the main exynos dtsi file and
specific board files in different patches.  Among other things it
makes backporting the patch and resolving merge conflicts easier (if
someone doesn't care about snow they could just pick up the main dtsi,
for instance).

I'm not a total stickler and I'd love to see this land quickly to
avoid conflicts, though...


> +&sd3_clk {
> +       samsung,pin-drv = <0>;
> +};
> +
> +&sd3_cmd {
> +       samsung,pin-pud = <3>;
> +       samsung,pin-drv = <0>;
> +};
> +
> +&sd3_bus4 {

Itty bitty bitty nit that "bus" sorts alphabetically above "clk".  ;)
Maybe Kukjin would be willing to sort these when he applies?


Thank you for all your hard work on this one.  Things look MUCH MUCH
nicer!  I did a pretty thorough review of your changes and it all
looks good.

Reviewed-by: Doug Anderson <dianders@chromium.org>
