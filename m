Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066AbaGUWwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:52:24 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:45529 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaGUWwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:52:20 -0400
MIME-Version: 1.0
In-Reply-To: <53CD860B.7030800@wwwdotorg.org>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
	<1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
	<CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>
	<53CD860B.7030800@wwwdotorg.org>
Date: Mon, 21 Jul 2014 15:52:19 -0700
X-Google-Sender-Auth: Dhcjv1r66osP6Y5TCV42cvDoH48
Message-ID: <CAL1qeaHtGQxCO3cGdeCRUYuk6mxei6z1B63-iZdBECEbFqGhHw@mail.gmail.com>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 2:28 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 07/11/2014 10:43 AM, Andrew Bresticker wrote:
>> On Fri, Jul 11, 2014 at 7:18 AM, Mikko Perttunen <mperttunen@nvidia.com> wrote:
>>> Add binding documentation for the nvidia,tegra124-emc device tree
>>> node.
>>
>>> diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
>>
>>> +Required properties :
>>> +- compatible : "nvidia,tegra124-emc".
>>> +- reg : Should contain 1 or 2 entries:
>>> +  - EMC register set
>>> +  - MC register set : Required only if no node with
>>> +    'compatible = "nvidia,tegra124-mc"' exists. The MC register set
>>> +    is first read from the MC node. If it doesn't exist, it is read
>>> +    from this property.
>>> +- timings : Should contain 1 entry for each supported clock rate.
>>> +  Entries should be named "timing@n" where n is a 0-based increasing
>>> +  number. The timings must be listed in rate-ascending order.
>>
>> There are upcoming boards which support multiple DRAM configurations
>> and require a separate set of timings for each configuration.  Could
>> we instead have multiple sets of timings with the proper one selected
>> at runtime by RAM code, as reported by PMC_STRAPPING_OPT_A_0?
>> Something like:
>>
>> emc {
>>         emc-table@0 {
>>                 nvidia,ram-code = <0>;
>>                 timing@0 {
>>                         ...
>>                 };
>>                 ...
>>         };
>
> Until recently, there was a binding for Tegra20 EMC in mainline. We
> should make sure the Tegra124 driver (or rather binding...) is at least
> as feature-ful as that was.
>
> Furthermore, I thought that with some boards, there were more RAM
> options that there were available RAM code strap bits. I assume that in
> mainline, we'll simply have different base DT files for the different
> sets of configurations? Or, will we want to add another level to the DT
> to represent different sets of RAM code values? I'm not sure what data
> source the bootloader uses to determine which set of RAM configuration
> to use when there aren't enough entries in the BCT for the boot ROM to
> do this automatically, and whether we have any way to get that value
> into the kernel, so it could use it for the extra DT level lookup?

For the ChromeOS boards at least we are neither limited by the number
of strapping bits (4) nor the number of BCT entries supported by the
boot ROM (since coreboot does not rely on the boot ROM for SDRAM
initialization), so having a single set of SDRAM configurations for
each board, indexed by APBDEV_PMC_STRAPPING_OPT_A_0[7:4] works just
fine.  Not sure how boards which do use the boot ROM for SDRAM
initialization handle the BCT limitation.  I believe we considered
using more board ID strapping bits in order to map the RAM codes to
sets of configurations before switching to having coreboot do SDRAM
initialization.
