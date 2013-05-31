Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab3EaWkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:40:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49434 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3EaWkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:40:39 -0400
Message-ID: <51A926A4.5010800@infradead.org>
Date: Fri, 31 May 2013 15:39:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Emil Goode <emilgoode@gmail.com>, balbi@ti.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] usb: musb: Fix format specifier warning
References: <1370031778-25965-1-git-send-email-emilgoode@gmail.com> <CAHp75VciHQKcyj-ANLdg=mg2C71zn=09Eentf22q+otGu=rp3w@mail.gmail.com>
In-Reply-To: <CAHp75VciHQKcyj-ANLdg=mg2C71zn=09Eentf22q+otGu=rp3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/13 15:34, Andy Shevchenko wrote:
> On Fri, May 31, 2013 at 11:22 PM, Emil Goode <emilgoode@gmail.com> wrote:
>> This patch fixes a format specifier warning. dma_addr_t can be either
>> u32 or u64 so we should cast to the largest type and change the format
>> specifier to %llx.
> 
> dma_addr_t is derived from phys_addr_t, thus you may use %pa specifier
> which is available from v3.8(?).
> 
> Something like this:
> dma_addr_t src_addr;
> dev_dbg(dev, "DMA addr: %pa\n", src_addr);

Isn't that:

  deb_dbg(dev, "DMA addr: %pa\n", &src_addr);


-- 
~Randy
