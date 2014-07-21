Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaGUV2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:28:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55643 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaGUV2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:28:46 -0400
Message-ID: <53CD860B.7030800@wwwdotorg.org>
Date: Mon, 21 Jul 2014 15:28:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>	<1405088313-20048-6-git-send-email-mperttunen@nvidia.com> <CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>
In-Reply-To: <CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 10:43 AM, Andrew Bresticker wrote:
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
>         emc-table@0 {
>                 nvidia,ram-code = <0>;
>                 timing@0 {
>                         ...
>                 };
>                 ...
>         };

Until recently, there was a binding for Tegra20 EMC in mainline. We
should make sure the Tegra124 driver (or rather binding...) is at least
as feature-ful as that was.

Furthermore, I thought that with some boards, there were more RAM
options that there were available RAM code strap bits. I assume that in
mainline, we'll simply have different base DT files for the different
sets of configurations? Or, will we want to add another level to the DT
to represent different sets of RAM code values? I'm not sure what data
source the bootloader uses to determine which set of RAM configuration
to use when there aren't enough entries in the BCT for the boot ROM to
do this automatically, and whether we have any way to get that value
into the kernel, so it could use it for the extra DT level lookup?
