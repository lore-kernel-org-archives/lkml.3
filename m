Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab3DLHuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 03:50:05 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:60742 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab3DLHuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 03:50:04 -0400
MIME-Version: 1.0
In-Reply-To: <201304111633.54110.arnd@arndb.de>
References: <1365669779-14953-1-git-send-email-linus.walleij@stericsson.com>
	<201304111633.54110.arnd@arndb.de>
Date: Fri, 12 Apr 2013 09:50:02 +0200
Message-ID: <CACRpkdaUMtNjODOGZ2TA+DKnA-T4TsTjhgM4TxaKV7N6fswVaQ@mail.gmail.com>
Subject: Re: [PATCH] MFD: ab8500: pass AB8500 IRQ to debugfs code by resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 4:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 11 April 2013, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> The AB8500 debug code which was merged in parallell with the
>> multiplatform work incidentally introduced a new instance using
>> the <mach/irqs.h> header which is now deleted, causing this
>> build regression:
>>
>> drivers/mfd/ab8500-debugfs.c:95:23:
>> fatal error: mach/irqs.h: No such file or directory
>> compilation terminated.
>> make[4]: *** [drivers/mfd/ab8500-debugfs.o] Error 1
>>
>> The code most certainly never worked with device tree either
>> since that does not rely on this kind of hard-coded interrupt
>> numbers.
>>
>> Fix the problem at the root by passing it as a named resource
>> from the ab8500-core driver.
>
> I think this won't work because the interrupts in ab8500_debug_resources
> are now local numbers relative to the ab8500->domain irq_domain,
> while IRQ_DB8500_AB8500 is an global interrupt number.

Actually, well, this one IRQ (the one I start to pass) is already
domain-mapped to the global IRQ numberspace, so that one will
be correct.

However the debug driver patch, i.e. the entire debugfs driver,
is completely irqdomain-unaware and has been broken for
device tree since forever and broken for non-dt builds since
the IRQ numbers were made local.

I guess I'll just have to cook a second patch to fix this up...

Yours,
Linus Walleij
