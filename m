Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbaGCIYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:24:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16335 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079AbaGCIYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:24:10 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-c5-53b5131d85c5
Message-id: <53B5131B.1060702@samsung.com>
Date: Thu, 03 Jul 2014 10:23:55 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
Newsgroups: gmane.comp.video.dri.devel,gmane.linux.ports.tegra,gmane.linux.kernel
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/4] drm/dsi: Add flag for continuous clock behavior
References: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
 <1404303560-32209-2-git-send-email-acourbot@nvidia.com>
In-reply-to: <1404303560-32209-2-git-send-email-acourbot@nvidia.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xa7qywluDDbZNYrf4/vAUq8WVr+/Z
	LC7vmsNm0fllFpvFq4NtLBan2mQtfu6ax+LA7rFz1l12j/vdx5k8epvfsXl83iTnsXFuaABr
	FJdNSmpOZllqkb5dAldGx5QPLAVN3BUHes4xNTBO5exi5OSQEDCRWL90DSuELSZx4d56ti5G
	Lg4hgaWMEgf2P2CFcD4xSky4e54FpIpXQEti79x1TCA2i4CqxO19q8C62QQ0Jf5uvskGYosK
	REgc6HvGClEvKPFj8j2gXg4OPoFgie8nBEBmigisZpTYNHcp2BxmgQSJ58f/gs0XFvCQOLZ4
	EiOILSRQK/H49ytmEJtTwEViwr+njBD1OhL7W6exQdjyEpvXvGWewCg4C8m6WUjKZiEpW8DI
	vIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJPS/7mBceszqEKMAB6MSD+8L/U3BQqyJZcWV
	uYcYJTiYlUR4p2/eEizEm5JYWZValB9fVJqTWnyIkYmDU6qBsXbZqmeGvOYcSm47O7MW5QmK
	hJ3tFZl//+9hxmcZ99I9p8dOXm4dctR0/dsYa61Hyvu8nm269kuVQe91pw7byU0Xsvr7hDcd
	Lvm5cVfFy4/KdxNynN7avAmdIK6y32B5Vuf1dz+0Jsz04Nl446SCmvwLnaU+t9gEElezFMXo
	nEjJshQsab0Wq8RSnJFoqMVcVJwIAOSinU9bAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alexandre,

Thanks for the patch.

On 07/02/2014 02:19 PM, Alexandre Courbot wrote:
> As per section 5.6.1 of the DSI specification, all DSI transmitters must
> support continuous clock behavior on the clock lane, while non-continuous
> mode support is only optional. Add a flag that allows devices to indicate
> that they require continuous clock mode to operate properly.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  include/drm/drm_mipi_dsi.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
> index 944f33f..5913ef4 100644
> --- a/include/drm/drm_mipi_dsi.h
> +++ b/include/drm/drm_mipi_dsi.h
> @@ -94,6 +94,8 @@ void mipi_dsi_host_unregister(struct mipi_dsi_host *host);
>  #define MIPI_DSI_MODE_VSYNC_FLUSH	BIT(8)
>  /* disable EoT packets in HS mode */
>  #define MIPI_DSI_MODE_EOT_PACKET	BIT(9)
> +/* use continuous clock behavior on the clock lane */
> +#define MIPI_DSI_MODE_CLOCK_CONTINUOUS	BIT(10)
>  

According to MIPI DSI specification "All DSI transmitters and receivers
shall support continuous clock behavior on the Clock Lane, and
optionally may support non-continuous clock behavior". It suggests that
continuous clock should be default behavior. So maybe better is to
introduce sth like:
+#define MIPI_DSI_MODE_CLOCK_NON_CONTINUOUS	BIT(10)


Regards
Andrzej
