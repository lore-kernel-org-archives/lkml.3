Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3A2SwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:52:04 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:43479 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3A2SwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:52:01 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <CACRpkdZuu0skVSPV5qcUx3g5UYGxzigeCDkN_NeuNB+Ak8m3wQ@mail.gmail.com>
References: <1359381151-28127-1-git-send-email-linus.walleij@stericsson.com>
	<20130128230059.GE7789@quad.lixom.net>
	<CACRpkdZuu0skVSPV5qcUx3g5UYGxzigeCDkN_NeuNB+Ak8m3wQ@mail.gmail.com>
Date: Tue, 29 Jan 2013 10:51:58 -0800
Message-ID: <CAOesGMjvVQXwi5VoW+NYsmRXm8EJutzunjA8QXOzcVVK09ER4A@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM: ux500: select the DB8540 pin controller
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 10:16 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Tue, Jan 29, 2013 at 12:00 AM, Olof Johansson <olof@lixom.net> wrote:
>> On Mon, Jan 28, 2013 at 02:52:31PM +0100, Linus Walleij wrote:
>>> From: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> The pin controller is an inherent part of the SoC, without
>>> it the system will not boot, thus it needs to be selected
>>> from Kconfig.
>>>
>>> Cc: arm@kernel.org
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>> ---
>>> Requesting ACK from ARM SoC on this patch.
>>
>> Acked-by: Olof Johansson <olof@lixom.net>
>
> Thanks!
>
>> ... but I wonder if this is growing out of hand. Since they will always
>> be selected (and required) for UX500_SOC_DB8500, why not just make them
>> silent options that default to y with that as a depend?
>
> So either I do it like this by using select FOO in the
> Kconfig for the affected SoC, or I just turn it around
> and make it depend on the affected SoC and select it
> to "y" default.
>
> It's like eating eggs from the little or big end or something.
>
> This current approach has the upside of not proliferating
> the SoC Kconfig symbol outside of the ARM tree, but
> I have no strong preference...
>
> All this stuff used to live in the arch/arm/mach-foo
> folders in the past, like the clocks you just have to
> default-enable it somehow.

Hm. Damned if we do, damned if we don't.

Well, the slightly awkward part is probably that we split them up in a
bunch of Kconfig options that we need to select, but at the end of the
day, they are all either selected or unselected together. So the
granularity just means more Kconfig select lines.

Still, not a horrible problem, it just started to look at bit
excessive in the arch/arm/mach-* Kconfig.


-Olof
