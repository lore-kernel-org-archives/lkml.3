Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbaGQKzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:55:54 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45785 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbaGQKzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:55:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1407151201170.24854@nanos>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-22-git-send-email-lftan@altera.com>
	<alpine.DEB.2.10.1407151201170.24854@nanos>
Date: Thu, 17 Jul 2014 18:55:49 +0800
X-Google-Sender-Auth: y-c02XWLVEdOnxNMgO6824NF4B0
Message-ID: <CAFiDJ5-UQ4pu1Hkc444yaA6cbttTXM7KM2eProGUkYgjqvOSUg@mail.gmail.com>
Subject: Re: [PATCH v2 21/29] nios2: Futex operations
From: Ley Foon Tan <lftan@altera.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 6:03 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 15 Jul 2014, Ley Foon Tan wrote:
>  +static inline int atomic_futex_op_xchg_set(int oparg, u32 __user *uaddr,
>> +                                        int *oldval)
>> +{
>> +     unsigned long flags;
>> +     int ret;
>> +
>> +     local_irq_save(flags);
>> +
>> +     ret = get_user(*oldval, uaddr);
>> +     if (!ret)
>> +             ret = put_user(oparg, uaddr);
>
> This is wrong as it gets. get_user() might fault and sleep.
>
> You need a proper implementation, which handles fault exceptions.
I have checked that we use nios2 specific get_user() in [1]. This
function will not sleep and it handles fault exception.
I think this should be fine.

[1] http://rocketboards.org/gitweb/?p=linux-socfpga-next.git;a=blob;f=arch/nios2/include/asm/uaccess.h;h=3e36f536afaba24c308a8416a66b8a2573e042a5;hb=refs/heads/nios2-upstream

Regards
Ley Foon
