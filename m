Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3IBH27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:28:59 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59763 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab3IBH25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <2081838.eZHRxlDf7s@flatron>
References: <1377770268-14014-1-git-send-email-acourbot@nvidia.com>
 <1377770268-14014-2-git-send-email-acourbot@nvidia.com> <2081838.eZHRxlDf7s@flatron>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 2 Sep 2013 16:28:36 +0900
Message-ID: <CAAVeFuJ=z-29gp9=caQaxRGCiOQSnPLfafia3eCgWAUuny3GBg@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] ARM: add basic Trusted Foundations support
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz!

On Fri, Aug 30, 2013 at 5:20 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> +Required properties:
>> +- compatible : "tl,trusted-foundations"
>> +- version-major : major version number of Trusted Foundations firmware
>> +- version-minor: minor version number of Trusted Foundations firmware
>
> Hmm, maybe you could simply define a single version property that could
> have multiple cells? Like:
>
>         firmware {
>                 compatible = "tl,trusted-foundations";
>                 version = <2 8>;
>         };

I'm fine this way too, but do we have other bindings that use the same
scheme? What is the general convention for version number bindings?

>> +       This option allows the kernel to invoke the secure monitor
> whenever
>> +       required on devices using Trusted Foundations.
>> +
>> +       Devices using Trusted Foundations should pass a device tree
>> containing +    a node compatible with "tl,trusted-foundations" to
>> signal the presence +   of the secure monitor.
>
> What about pointing to the documentation file instead?

Yes, that would make more sense.

>> +void of_register_trusted_foundations(void)
>> +{
>> +     struct device_node *node;
>> +
>> +     node = of_find_compatible_node(NULL, NULL, "tl,trusted-
> foundations");
>
> nit:
>         if (!node)
>                 return;

Fixed, thanks.

>> +static inline void register_trusted_foundations(
>> +                                struct
> trusted_foundations_platform_data *pd)
>> +{
>> +     pr_crit("No support for Trusted Foundations, stopping...\n");
>> +     BUG();
>
> Hmm, why not simply panic()?

Fixed that too.

Thanks for the review!
Alex.
