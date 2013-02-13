Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab3BMSvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:51:14 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:55578 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab3BMSvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:51:12 -0500
MIME-Version: 1.0
In-Reply-To: <20130212225227.GA24096@quad.lixom.net>
References: <1360706692-13622-1-git-send-email-robherring2@gmail.com>
	<20130212225227.GA24096@quad.lixom.net>
Date: Wed, 13 Feb 2013 10:51:10 -0800
X-Google-Sender-Auth: KJ-hPlswNmz6Lb-5RUmA4ozuDI8
Message-ID: <CAD=FV=WcHuW+2KBqDOGezW2Q9Fhr3Zq-ZtpX_y5qKN2LFEgMDA@mail.gmail.com>
Subject: Re: [PATCH] ARM: exynos: move exynos4210-combiner to drivers/irqchip
From: Doug Anderson <dianders@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Rob Herring <robherring2@gmail.com>, arm@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob / Olof,

On Tue, Feb 12, 2013 at 2:52 PM, Olof Johansson <olof@lixom.net> wrote:
> On Tue, Feb 12, 2013 at 04:04:52PM -0600, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Exynos boot is broken with commit 0529e315 (ARM: use common irqchip_init
>> for GIC init). This commit split the irqchip initialization into 2 calls
>> to of_irq_init. This does not work because of_irq_init requires interrupt
>> parents to be in the match list.
>>
>> Rather than reverting exynos changes, make it do the proper thing by using
>> IRQCHIP_DECLARE. This requires moving the combiner code to drivers/irqchip.
>>
>> Reported-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: linux-samsung-soc@vger.kernel.org
>> ---
>>
>> I thought there may be other platforms broken in the same way, but I
>> checked and exynos is the only one.
>>
>> This is based on my gic/vic irqchip branch in arm-soc.
>
> Applied to next/cleanup.

I synced up to next-20130213 and the problem is fixed.  :)  ...that
label doesn't exactly boot but the problems are unrelated to this
problem now (there are problems with the OF conversions to raw
spinlocks)...

I haven't done any review of this code (I'm assuming that Olof already
looked it over and Samsung engineers will give it a thorough review),
but it's definitely tested.  :)

Tested-by: Doug Anderson <dianders@chromium.org>

Thanks!

-Doug
