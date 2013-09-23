Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3IWUhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:37:41 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35393 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3IWUhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:37:38 -0400
MIME-Version: 1.0
In-Reply-To: <87d2o4edus.fsf@linaro.org>
References: <1379238028-7960-1-git-send-email-acourbot@nvidia.com>
 <1379238028-7960-2-git-send-email-acourbot@nvidia.com> <87d2o4edus.fsf@linaro.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 24 Sep 2013 05:37:17 +0900
Message-ID: <CAAVeFuLs5SPic-khRG87TxuAVcC3nJeAhjSHyESKRQXvfMzQ5w@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] ARM: add basic support for Trusted Foundations
To: Kevin Hilman <khilman@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 5:49 AM, Kevin Hilman <khilman@linaro.org> wrote:
> Alexandre Courbot <acourbot@nvidia.com> writes:
>
>> Trusted Foundations is a TrustZone-based secure monitor for ARM that
>> can be invoked using the same SMC-based API on all supported
>> platforms. This patch adds initial basic support for Trusted
>> Foundations using the ARM firmware API. Current features are limited
>> to the ability to boot secondary processors.
>
> [...]
>
>> +#if IS_ENABLED(CONFIG_OF)
>> +void of_register_trusted_foundations(void)
>> +{
>> +     struct device_node *node;
>> +     struct trusted_foundations_platform_data pdata;
>> +     int err;
>> +
>> +     node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
>> +     if (!node)
>> +             return;
>> +
>> +     err = of_property_read_u32(node, "version-major", &pdata.version_major);
>> +     if (err != 0)
>> +             panic("Trusted Foundation: missing version-major property\n");
>
> Do really need to panic() the whole kernel for a missing property?
> Surely this can more gracefully recover, or assume some defaults?
>
> Same comment for the other uses of panic() in this patch.

For something as essential as the secure monitor (for which there
cannot be "safe" defaults) it makes sense to have the version
explicitly mentioned. Version is a mandatory property in the bindings,
its implementors just need to follow it.

As for the other uses of panic(), that's because you just cannot
reasonably continue booting the system if trusted foundations is
required but not support for it is built into the kernel. Once again,
I don't feel this is out of place.

Alex.
