Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3A2SQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:16:25 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:51517 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3A2SQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:16:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130128230059.GE7789@quad.lixom.net>
References: <1359381151-28127-1-git-send-email-linus.walleij@stericsson.com>
	<20130128230059.GE7789@quad.lixom.net>
Date: Tue, 29 Jan 2013 19:16:23 +0100
Message-ID: <CACRpkdZuu0skVSPV5qcUx3g5UYGxzigeCDkN_NeuNB+Ak8m3wQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM: ux500: select the DB8540 pin controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 12:00 AM, Olof Johansson <olof@lixom.net> wrote:
> On Mon, Jan 28, 2013 at 02:52:31PM +0100, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> The pin controller is an inherent part of the SoC, without
>> it the system will not boot, thus it needs to be selected
>> from Kconfig.
>>
>> Cc: arm@kernel.org
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>> Requesting ACK from ARM SoC on this patch.
>
> Acked-by: Olof Johansson <olof@lixom.net>

Thanks!

> ... but I wonder if this is growing out of hand. Since they will always
> be selected (and required) for UX500_SOC_DB8500, why not just make them
> silent options that default to y with that as a depend?

So either I do it like this by using select FOO in the
Kconfig for the affected SoC, or I just turn it around
and make it depend on the affected SoC and select it
to "y" default.

It's like eating eggs from the little or big end or something.

This current approach has the upside of not proliferating
the SoC Kconfig symbol outside of the ARM tree, but
I have no strong preference...

All this stuff used to live in the arch/arm/mach-foo
folders in the past, like the clocks you just have to
default-enable it somehow.

Linus Walleij
