Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaFPUGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:06:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58231 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbaFPUGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:06:47 -0400
Message-ID: <539F4E53.6080205@wwwdotorg.org>
Date: Mon, 16 Jun 2014 14:06:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 3/4] drm/tegra: Request memory bandwidth for the display
 controller
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com> <1402925713-25426-4-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1402925713-25426-4-git-send-email-tomeu.vizoso@collabora.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
> Request it based solely on the current mode's refresh rate. More
> accurate requirements can be requested in future patches.

> diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c

> +	bandwidth = mode->clock * window.bits_per_pixel / 8;
> +	err = tegra124_emc_reserve_bandwidth(TEGRA_EMC_CONSUMER_DISP1, bandwidth);

DISP1 shouldn't be hard-coded here; the code should use DISP1 or DISP2
based on head or DC identity. We certainly have some boards capable of
dual-head operation.
