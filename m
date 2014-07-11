Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaGKQnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:43:40 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37156 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaGKQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:43:38 -0400
MIME-Version: 1.0
In-Reply-To: <1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
	<1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
Date: Fri, 11 Jul 2014 09:43:37 -0700
X-Google-Sender-Auth: dxodq96c44Ye968P0v_LdeIOXmQ
Message-ID: <CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
From: Andrew Bresticker <abrestic@chromium.org>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 7:18 AM, Mikko Perttunen <mperttunen@nvidia.com> wrote:
> Add binding documentation for the nvidia,tegra124-emc device tree
> node.

> diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt

> +Required properties :
> +- compatible : "nvidia,tegra124-emc".
> +- reg : Should contain 1 or 2 entries:
> +  - EMC register set
> +  - MC register set : Required only if no node with
> +    'compatible = "nvidia,tegra124-mc"' exists. The MC register set
> +    is first read from the MC node. If it doesn't exist, it is read
> +    from this property.
> +- timings : Should contain 1 entry for each supported clock rate.
> +  Entries should be named "timing@n" where n is a 0-based increasing
> +  number. The timings must be listed in rate-ascending order.

There are upcoming boards which support multiple DRAM configurations
and require a separate set of timings for each configuration.  Could
we instead have multiple sets of timings with the proper one selected
at runtime by RAM code, as reported by PMC_STRAPPING_OPT_A_0?
Something like:

emc {
        emc-table@0 {
                nvidia,ram-code = <0>;
                timing@0 {
                        ...
                };
                ...
        };
        emc-table@1 {
                nvidia,ram-code = <4>;
                timing@0 {
                        ...
                };
                ...
        };
        ...
};
