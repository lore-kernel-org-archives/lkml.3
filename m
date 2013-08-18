Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3HRIhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:37:23 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:55585 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3HRIhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:37:21 -0400
MIME-Version: 1.0
In-Reply-To: <520BF8BD.7050706@wwwdotorg.org>
References: <1376360992-1508-1-git-send-email-acourbot@nvidia.com>
 <1376360992-1508-3-git-send-email-acourbot@nvidia.com> <520BF8BD.7050706@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 18 Aug 2013 17:37:00 +0900
Message-ID: <CAAVeFuJY_UkS8rF=xfB0uEpJp4bZpc77i599bP4qmY9Xr91PSQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] ARM: tegra: add support for Trusted Foundations
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Joseph Lo <josephl@nvidia.com>, Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 6:38 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/12/2013 08:29 PM, Alexandre Courbot wrote:
>> Register the firmware operations for Trusted Foundations if the device
>> tree indicates it is active on the device.
>
>> diff --git a/arch/arm/mach-tegra/firmware.c b/arch/arm/mach-tegra/firmware.c
>
>> +void __init tegra_init_firmware(void)
>> +{
>> +     struct device_node *node;
>> +
>> +     if (!of_have_populated_dt())
>> +             return;
>
> That's never false on Tegra, at least upstream.

Will remove, thanks.

>> +     node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
>> +     if (node) {
>> +             const char *tf_version;
>> +             int err;
>> +
>> +             err = of_property_read_string(node, "version", &tf_version);
>> +             if (err != 0) {
>> +                     pr_crit("Cannot read Trusted Foundation version: %d\n",
>> +                             err);
>> +                     BUG();
>> +             } else {
>> +                     register_trusted_foundations(tf_version);
>> +             }
>> +     }
>> +}
>
> I think most/all of that function will be common across all SoCs that
> support the TF monitor. I think you want to move the code into
> register_trusted_foundations() (or a function that calls that) in patch 1?

Agreed. If we push the logic a bit further, we should also have some
platform parameters for non-DT users, along with an
of_register_trusted_foundations() for those who prefer DT.

Thanks,
Alex.
