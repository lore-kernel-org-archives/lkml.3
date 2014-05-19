Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaESVPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:15:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38251 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaESVPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:15:00 -0400
Message-ID: <537A7450.5030904@wwwdotorg.org>
Date: Mon, 19 May 2014 15:14:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>, Ben Skeggs <bskeggs@redhat.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [PATCH 2/5] ARM: tegra: of: add GK20A device tree binding
References: <1400491450-19223-1-git-send-email-acourbot@nvidia.com> <1400491450-19223-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1400491450-19223-3-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 03:24 AM, Alexandre Courbot wrote:
> Add the device tree binding documentation for the GK20A GPU used in
> Tegra K1 SoCs.

A few minor nits, but otherwise,
Acked-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt b/Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt

> +Required properties:
> +- compatible: "nvidia,<chip>-<gpu>"
> +  Currently recognized values:
> +  - nvidia,tegra124-gk20a
> +- reg: Physical base address and length of the controller's registers.
> +  Must contain two entries:
> +  - first entry for bar0
> +  - second entry for bar1
> +- interrupts: The interrupt outputs from the controller.

To be consistent with the clocks and resets properties, it'd be nice to
reword that as:

interrupts: Must contain an entry for each entry in interrupt-names.

> +- interrupt-names: Must include the following entries:

... and add the following here:

See ../interrupt-controller/interrupts.txt

> +/ {

No need to wrap a root node around this in the example.

> +	gpu@0,57000000 {
...
> +	};
> +

Extra blank line here.

> +};

