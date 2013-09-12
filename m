Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3ILKAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:00:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43246 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3ILKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:00:21 -0400
MIME-Version: 1.0
In-Reply-To: <522DF058.8020509@wwwdotorg.org>
References: <1378351680-14696-1-git-send-email-acourbot@nvidia.com>
 <1378351680-14696-2-git-send-email-acourbot@nvidia.com> <522A2D1B.3010508@wwwdotorg.org>
 <CAAVeFuJF-cu9aPCruGPQk9WHV7VAGhGpU0bU6LToxP38YBnS_g@mail.gmail.com> <522DF058.8020509@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 12 Sep 2013 19:00:00 +0900
Message-ID: <CAAVeFu+gAvc5gE5_vKXsYET6nCRmP36io_aem02pS3M3rmf9iQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] ARM: add basic Trusted Foundations support
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 12:59 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/09/2013 12:38 AM, Alexandre Courbot wrote:
>> On Sat, Sep 7, 2013 at 4:29 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 09/04/2013 09:27 PM, Alexandre Courbot wrote:
>>>> Trusted Foundations is a TrustZone-based secure monitor for ARM that
>>>> can be invoked  using a consistent SMC-based API on all supported
>>>> platforms. This patch adds initial basic support for Trusted
>>>> Foundations using the ARM firmware API. Current features are limited
>>>> to the ability to boot secondary processors.
>
>>>> diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h
>>>
>>> Do we need to add the following here:
>>>
>>> #if !IS_ENABLED(CONFIG_OF)
>>> static inline void register_trusted_foundations(...) {}
>>> #endif
>
> Uggh. I meant to write **of_**register_trusted_foundations() there.
>
>>> So that there is a dummy no-op function for the non-DT-support case? I
>>> guess Tegra always has CONFIG_OF enabled so that call from
>>> mach-tegra/common.c in patch 2 will never be an issue, but perhaps it
>>> might if anyone else uses this?
>>
>> My expectation is that register_trusted_foundations() is called by the
>> platform code once it has established (through whatever mean it likes)
>> that Trusted Foundations is required. For platforms supporting DT,
>> of_register_trusted_foundations() takes care of that. Platforms that
>> don't support DT need another way to decide whether they *need* TF or
>> not. Once a platform decided that it needs TF, its absence is not an
>> option, and therefore I'd think that register_trusted_foundations()
>> should hard-fail if support is not compiled in. Or maybe I missed your
>> point?
>
> So yes, you missed my point, but it was my fault:-)
>
> Most of_* can be called irrespective of CONFIG_OF, and since
> of_register_trusted_foundations() is meant to handle internally the "do
> I need to do anything" case, I think it makes sense to be allowed to
> call it unconditionally without determining anything about either
> CONFIG_OF or TF DT node presence?

Ah, ok, I follow you now. I wasn't sure what the convention was here,
but yeah, I see nothing against making a no-op
of_register_trusted_foundations() available when CONFIG_OF is not
enabled.

Thanks,
Alex.
