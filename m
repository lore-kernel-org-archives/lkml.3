Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaIBCZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 22:25:58 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:47373 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaIBCZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 22:25:56 -0400
MIME-Version: 1.0
X-Originating-IP: [220.129.154.48]
In-Reply-To: <20140902021119.GA2525@kroah.com>
References: <1407033419.17812.2.camel@phoenix>
	<CAFRkauB=2f5-zN5OAwx0LSYSnwuub_ONL+LuYYdy6-MxWQNzLw@mail.gmail.com>
	<20140902021119.GA2525@kroah.com>
Date: Tue, 2 Sep 2014 10:25:55 +0800
Message-ID: <CAFRkauB3gcNjP-3_kvbYS6Zi3p1QwHsZs6SkPOLE-LAbpb=uyQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpu: ipu-v3: Select GENERIC_IRQ_CHIP to fix build error
From: Axel Lin <axel.lin@ingics.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-02 10:11 GMT+08:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Tue, Sep 02, 2014 at 09:47:37AM +0800, Axel Lin wrote:
>> 2014-08-03 10:36 GMT+08:00 Axel Lin <axel.lin@ingics.com>:
>> > This driver uses GENERIC_IRQ_CHIP, so it needs to select GENERIC_IRQ_CHIP to
>> > avoid build error.
>> >
>> > Fixes below build errors:
>> > ERROR: "irq_alloc_domain_generic_chips" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
>> > ERROR: "irq_gc_mask_clr_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
>> > ERROR: "irq_gc_mask_set_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
>> > ERROR: "irq_generic_chip_ops" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
>> > ERROR: "irq_gc_ack_set_bit" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
>> > ERROR: "irq_get_domain_generic_chip" [drivers/gpu/ipu-v3/imx-ipu-v3.ko] undefined!
>> > make[1]: *** [__modpost] Error 1
>> > make: *** [modules] Error 2
>>
>> Hi Greg,
>>
>> I still hit this build error in today's linuex-next tree with below config:
>> ARCH_MULTIPLATFORM && !SOC_IMX5 && !SOC_IMX6Q && !SOC_IMX6SL
>>
>> This driver just moved from staging to gpu.
>> So it's not clear to me who will pick up this patch.
>> Can you pick up this patch?
>
> As the code isn't in the staging tree, why shouldn't it go through the
> drivers/gpu/* maintainer?

scripts/get_maintainer.pl
sent/0001-gpu-ipu-v3-select-GENERIC_IRQ_CHIP-to-fix-build-erro.patch
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (commit_signer:1/1=100%)
Lucas Stach <l.stach@pengutronix.de> (commit_signer:1/1=100%)
Philipp Zabel <p.zabel@pengutronix.de>
(commit_signer:1/1=100%,authored:1/1=100%,added_lines:7/7=100%)
linux-kernel@vger.kernel.org (open list)

I checked the MAINTAINERS file,
I can only find the maintainer for some subfolders of drivers/gpu but no entry
for drivers/gpu/ipu-v3.
So I'm not sure who is the maintainer for drivers/gpu/ipu-v3.

Thanks,
Axel
