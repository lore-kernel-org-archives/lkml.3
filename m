Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab3IIGca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:32:30 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:62468 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3IIGc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:32:28 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaphSqM1oOphC-t1UPmkxaEemC3R3aDfEXb79GWNNyNMA@mail.gmail.com>
References: <1378351680-14696-1-git-send-email-acourbot@nvidia.com>
 <1378351680-14696-2-git-send-email-acourbot@nvidia.com> <CACRpkdaphSqM1oOphC-t1UPmkxaEemC3R3aDfEXb79GWNNyNMA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 9 Sep 2013 15:32:08 +0900
Message-ID: <CAAVeFuKq=DVeG6BZ0jg_88+X_XroioY15C43wQA1mnvHVcjsLQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] ARM: add basic Trusted Foundations support
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 7, 2013 at 1:48 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Sep 5, 2013 at 5:27 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>
>> Trusted Foundations is a TrustZone-based secure monitor for ARM that
>> can be invoked  using a consistent SMC-based API on all supported
>> platforms. This patch adds initial basic support for Trusted
>> Foundations using the ARM firmware API. Current features are limited
>> to the ability to boot secondary processors.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>> Reviewed-by: Stephen Warren <swarren@nvidia.com>
>
> I take it that this means that it is a set of standard routines
> living in the secure world that can be called by way of this
> API, correct? The commit message is written a bit like
> everybody knows what this is about but I don't :-)

It's actually written a bit like I don't really know what this is
about, thanks for exposing my ignorance. :P

> Some more background here would be nice, like where did this
> thing come from, and are there other platforms in existance that
> use trusted foundations or is it a Tegra-only thing? Does a
> specification of this thing listing available services exist for
> example?

There is unfortunately no public specification of this AFAIK. Client
(kernel) side sources are available as Tegra downstream kernel
releases, but that's about it.

> How does it relate to the (arch-neutral) trusted execution
> environment and such things that other vendors are pushing for?
> Can the trusted foundations be used "underneath" such
> frameworks for trusted applications, or is it a parallell thing
> altogether?

My understanding is that TF serves the same purpose for ARM only AFAICT.

> I tried googling it, is this a relevant URL?
> http://www.arm.com/community/partners/display_product/rw/ProductId/5393/

Yes. TF is an essential feature to support in order to boot the kernel
on some Tegra-based consumer devices (e.g. SHIELD). Basic things such
as secondary CPU control must be performed through SMCs. It has many
more features but for the moment I don't see a need to go beyond the
very basic.

The issue is that as you pointed out, public information is scarce and
future direction uncertain. That's why this patchset limits itself to
what is needed to get secondary CPUs running - the procedure is very
simple and unlikely to change in the future. DT binding is also as
concise as possible to allow malleability since we cannot predict how
it will evolve in the future.

I will try to explain better what TF is in the commit log - at least
as far as I understand it myself.

Alex.
