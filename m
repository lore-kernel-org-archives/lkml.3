Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbaGQPkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:40:18 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:48969 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145AbaGQPkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:40:16 -0400
Message-ID: <53C7EE59.1050102@collabora.co.uk>
Date: Thu, 17 Jul 2014 17:40:09 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sebastian Reichel <sre@kernel.org>
CC: olof@lixom.net, Sachin Kamat <sachin.kamat@linaro.org>,
        ajaykumar.rs@samsung.com, linux-samsung-soc@vger.kernel.org,
        broonie@kernel.org, lee.jones@linaro.org,
        Anton Vorontsov <anton@enomsg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v3] charger: tps65090: Allow charger module to
 be used when no irq
References: <1403300523-17310-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1403300523-17310-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 06/20/2014 11:42 PM, Doug Anderson wrote:
> On the ARM Chromebook tps65090 has two masters: the AP (the main
> processor running linux) and the EC (the embedded controller).  The AP
> is allowed to mess with FETs but the EC is in charge of charge control.
> 
> The tps65090 interupt line is routed to both the AP and the EC, which
> can cause quite a headache.  Having two people adjusting masks and
> acking interrupts is a recipe for disaster.
> 
> In the shipping kernel we had a hack to have the AP pay attention to
> the IRQ but not to ack it.  It also wasn't supposed to configure the
> IRQ in any way.  That hack allowed us to detect when the device was
> charging without messing with the EC's state.
> 
> The current tps65090 infrastructure makes the above difficult, and it
> was a bit of a hack to begin with.  Rather than uglify the driver to
> support it, just extend the driver's existing notion of "no irq" to
> the charger.  This makes the charger code poll every 2 seconds for AC
> detect, which is sufficient.
> 
> For proper functioning, requires (mfd: tps65090: Don't tell child
> devices we have an IRQ if we don't).  If we don't have that patch
> we'll simply fail to probe on devices without an interrupt (just like
> we did before this patch).
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v2:
> - Split noirq (polling mode) changes into MFD and charger
> 
> This patch has been sent up a number of times with no response.  It's
> needed to make the charger work on exynos5250-snow,
> exynos5420-peach-pit, and exynos5800-peach-pi.  It was originally part
> of a series as <https://patchwork.kernel.org/patch/4042751/> and the
> rest of the series has long since landed.
> 

Looks good to me. Also since this patch makes optional to get an IRQ, the
following annoying message is not shown anymore:

[    2.132944] tps65090-charger tps65090-charger: Unable to get charger irq = -6

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
