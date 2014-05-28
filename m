Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaE1Nc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:32:59 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:58445 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaE1Nc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:32:57 -0400
MIME-Version: 1.0
In-Reply-To: <4960549.viM91iY2g2@wuerfel>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	<5840140.8yGnd4Ycx3@wuerfel>
	<CACRpkdZjEVYgq7tKEfmZC0Fu4n=JuUues=pAAtquLahkex=pkA@mail.gmail.com>
	<4960549.viM91iY2g2@wuerfel>
Date: Wed, 28 May 2014 15:32:56 +0200
Message-ID: <CACRpkda5x-fJWTN40ze17woMWuWoVbuhbNu5nkm1sFcdJchRfA@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 3:29 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 28 May 2014 10:23:09 Linus Walleij wrote:

>>         model = "ARM Integrator/AP";
>>         compatible = "arm,integrator-ap";
>> +       dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;
>>
>>         aliases {
>>                 arm,timer-primary = &timer2;
>>
>
> It looks like you accidentally copied the ranges from keystone, even
> though that has a 64-bit root bus and you only have 32-bit.

Nah it was no accident, just good old incompetence ;-)

> I suspect what you want is
>
>         dma-ranges = <0x80000000 0 0x80000000>;
>
> to translate dma_addr_t 0x80000000-0xffffffff to phys_addr_t 0x0-0x7fffffff
> rather than phys_addr_t 0x800000000-0x87fffffff.

Thanks, I'll fix up my patch.

Yours,
Linus Walleij
