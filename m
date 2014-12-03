Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaLCT5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:57:10 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:52802 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaLCT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:57:08 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc\@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene@kernel.org>, Inki Dae <inki.dae@samsung.com>,
        Tobias Jakobi <Liquid.Acid@gmx.net>, Daniel Drake <drake@endlessm.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v2 2/7] ARM: Exynos: add support for sub-power domains
References: <1416814256-24288-3-git-send-email-a.hajda@samsung.com>
	<1417610024-29748-1-git-send-email-m.szyprowski@samsung.com>
	<CAMuHMdWjZTRVrdcdu2toj9FYi5gOgw_Hf23SRh=9-QKwQDJy0g@mail.gmail.com>
	<547F065A.5030505@samsung.com>
Date: Wed, 03 Dec 2014 11:57:05 -0800
In-Reply-To: <547F065A.5030505@samsung.com> (Marek Szyprowski's message of
	"Wed, 03 Dec 2014 13:47:22 +0100")
Message-ID: <7hvblsy0a6.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Szyprowski <m.szyprowski@samsung.com> writes:

> Hello,
>
> On 2014-12-03 13:36, Geert Uytterhoeven wrote:
>> Hi Marek,
>>
>> On Wed, Dec 3, 2014 at 1:33 PM, Marek Szyprowski
>> <m.szyprowski@samsung.com> wrote:
>>> diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>>> index abde1ea8a119..b884358ebb1a 100644
>>> --- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>>> +++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>>> @@ -22,6 +22,8 @@ Optional Properties:
>>>          - pclkN, clkN: Pairs of parent of input clock and input clock to the
>>>                  devices in this power domain. Maximum of 4 pairs (N = 0 to 3)
>>>                  are supported currently.
>>> +- samsung,power-domain: phandle to a master power domain that the given domain
>>> +                      is a part of
>> For new DTSes I'd recommend using the generic "power-domains" only.
>
> I think that some consistency in dts style will be really an added
> value. In my opinion for
> all existing DTSes we should keep using 'samsung,power-domain' (even
> for defining a parent
> power domains) and for all new DTSes, the generic 'power-domains'
> binding should be used.

Or even better, convert the existing DTSs to use generic power-domain
first, and then use generic ones going forward also.

Kevin
