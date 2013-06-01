Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab3FANPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 09:15:07 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:44408 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab3FANPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 09:15:05 -0400
MIME-Version: 1.0
In-Reply-To: <51A926A4.5010800@infradead.org>
References: <1370031778-25965-1-git-send-email-emilgoode@gmail.com>
	<CAHp75VciHQKcyj-ANLdg=mg2C71zn=09Eentf22q+otGu=rp3w@mail.gmail.com>
	<51A926A4.5010800@infradead.org>
Date: Sat, 1 Jun 2013 16:15:03 +0300
Message-ID: <CAHp75Vd3frBwPa=DQiKrkkcPdOooBGUS=tYC6STw+o1gW1zf6Q@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: Fix format specifier warning
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Emil Goode <emilgoode@gmail.com>, balbi@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 1:39 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 05/31/13 15:34, Andy Shevchenko wrote:
>> On Fri, May 31, 2013 at 11:22 PM, Emil Goode <emilgoode@gmail.com> wrote:
>>> This patch fixes a format specifier warning. dma_addr_t can be either
>>> u32 or u64 so we should cast to the largest type and change the format
>>> specifier to %llx.
>>
>> dma_addr_t is derived from phys_addr_t, thus you may use %pa specifier
>> which is available from v3.8(?).
>>
>> Something like this:
>> dma_addr_t src_addr;
>> dev_dbg(dev, "DMA addr: %pa\n", src_addr);
>
> Isn't that:
>
>   deb_dbg(dev, "DMA addr: %pa\n", &src_addr);

It's.
You are right.

--
With Best Regards,
Andy Shevchenko
