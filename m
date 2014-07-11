Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaGKQsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:48:42 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:36443 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaGKQsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:48:39 -0400
Message-ID: <53C01560.3070200@kapsi.fi>
Date: Fri, 11 Jul 2014 19:48:32 +0300
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>	<1405088313-20048-6-git-send-email-mperttunen@nvidia.com> <CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>
In-Reply-To: <CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:be5f:f4ff:fe47:6518
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, I'll do that for v2.

On 07/11/2014 07:43 PM, Andrew Bresticker wrote:
> On Fri, Jul 11, 2014 at 7:18 AM, Mikko Perttunen <mperttunen@nvidia.com> wrote:
>> Add binding documentation for the nvidia,tegra124-emc device tree
>> node.
>
>> diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
>
>> +Required properties :
>> +- compatible : "nvidia,tegra124-emc".
>> +- reg : Should contain 1 or 2 entries:
>> +  - EMC register set
>> +  - MC register set : Required only if no node with
>> +    'compatible = "nvidia,tegra124-mc"' exists. The MC register set
>> +    is first read from the MC node. If it doesn't exist, it is read
>> +    from this property.
>> +- timings : Should contain 1 entry for each supported clock rate.
>> +  Entries should be named "timing@n" where n is a 0-based increasing
>> +  number. The timings must be listed in rate-ascending order.
>
> There are upcoming boards which support multiple DRAM configurations
> and require a separate set of timings for each configuration.  Could
> we instead have multiple sets of timings with the proper one selected
> at runtime by RAM code, as reported by PMC_STRAPPING_OPT_A_0?
> Something like:
>
> emc {
>          emc-table@0 {
>                  nvidia,ram-code = <0>;
>                  timing@0 {
>                          ...
>                  };
>                  ...
>          };
>          emc-table@1 {
>                  nvidia,ram-code = <4>;
>                  timing@0 {
>                          ...
>                  };
>                  ...
>          };
>          ...
> };
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

