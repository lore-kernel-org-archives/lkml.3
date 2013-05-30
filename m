Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965367Ab3E3RVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:21:06 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38160 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3E3RU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:20:58 -0400
MIME-Version: 1.0
In-Reply-To: <1369218014-28990-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369218014-28990-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 30 May 2013 19:20:58 +0200
Message-ID: <CACRpkdbY7WyH7kEOvNm1Gz_V8+MXMz2+1p6+YRvwX_gv7M+rWw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] gpio-langwell: initialize lock before usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 12:20 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> Otherwise we will end up with traceback from LOCKDEP:
>
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc2-next-20130521-00028-g09aa9fc #487
>  00000000 00000000 f6c55c54 c1541fe4 f6040bf8 f6c55c8c c1069ef1 c1726bc1
>  c1726cc8 c1726c9e 00000000 f6c584e0 f6c58000 f6c55ce8 00000000 f6040bf8
>  f6040bf8 00000046 f6c58000 f6c55d00 c106a18d 00000a2b 00000003 00004f02
> Call Trace:
>  [<c1541fe4>] dump_stack+0x49/0x77
>  [<c1069ef1>] register_lock_class+0x58/0x260
>  [<c106a18d>] __lock_acquire+0x94/0xcff
>  [<c106adc8>] ? __lock_acquire+0xccf/0xcff
>  [<c106b2ad>] lock_acquire+0xcc/0x10d
>  [<c1269c7c>] ? lnw_irq_type+0x63/0xe9
>  [<c1545da0>] _raw_spin_lock_irqsave+0x32/0x42
>  [<c1269c7c>] ? lnw_irq_type+0x63/0xe9
>  [<c1269c7c>] lnw_irq_type+0x63/0xe9
>  [<c108f454>] __irq_set_trigger+0x98/0x123
>  [<c1090225>] irq_set_irq_type+0x2f/0x51
>  [<c1090225>] ? irq_set_irq_type+0x2f/0x51
>  [<c1269d02>] ? lnw_irq_type+0xe9/0xe9
>  [<c1269d34>] lnw_gpio_irq_map+0x32/0x3b
>  [<c10914f2>] irq_domain_add_legacy+0xe2/0x107
>  [<c1091b53>] irq_domain_add_simple+0x47/0x60
>  [<c1269f6e>] lnw_gpio_probe+0x119/0x217
>  [<c1271018>] pci_device_probe+0x5a/0x92
> ...
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied.

Yours,
Linus Walleij
