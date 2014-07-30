Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaG3K6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:58:20 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:35840 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaG3K6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:58:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140730091215.GE10301@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-3-git-send-email-lftan@altera.com>
	<20140730091215.GE10301@distanz.ch>
Date: Wed, 30 Jul 2014 18:58:16 +0800
X-Google-Sender-Auth: kAoUTkSlaCkdtX3j28nSEidzfbU
Message-ID: <CAFiDJ596dR5XCPcAHJezFXR0dq4dMR0-dPFfmjEgpWv-9px=nw@mail.gmail.com>
Subject: Re: [PATCH v2 02/29] nios2: Kernel booting and initialization
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 5:12 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
>> +/*
>> + * Stack layout in 'ret_from_exception':
>> + *
>> + * This allows access to the syscall arguments in registers r4-r8
>> + *
>> + *    0(sp) - r8
>> + *    4(sp) - r9
>> + *    8(sp) - r10
>> + *    C(sp) - r11
>> + *   10(sp) - r12
>> + *   14(sp) - r13
>> + *   18(sp) - r14
>> + *   1C(sp) - r15
>> + *   20(sp) - r1
>> + *   24(sp) - r2
>> + *   28(sp) - r3
>> + *   2C(sp) - r4
>> + *   30(sp) - r5
>> + *   34(sp) - r6
>> + *   38(sp) - r7
>> + *   3C(sp) - orig_r2
>> + *   40(sp) - ra
>> + *   44(sp) - fp
>> + *   48(sp) - sp
>> + *   4C(sp) - gp
>> + *   50(sp) - estatus
>> + *   54(sp) - status_extension (NOMMU only)
>> + *   58(sp) - ea
>> + */
>
> status_extension no longer exists and orig_r7 is missing in the list
> above. Since this corresponds to the order of struct pt_regs anyhow,
> this comment seems rather pointless to me, so you might as well want to
> remove it altogether.
Okay, I will remove these comments.
Thanks for review.

Regards
Ley Foon
