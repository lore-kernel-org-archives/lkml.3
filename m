Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaGUDUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 23:20:05 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:61957 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbaGUDUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 23:20:02 -0400
MIME-Version: 1.0
In-Reply-To: <5659104.6O7AZx76W6@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<17186253.ZJUn1qWK0f@wuerfel>
	<alpine.DEB.2.10.1407181140250.24854@nanos>
	<5659104.6O7AZx76W6@wuerfel>
Date: Mon, 21 Jul 2014 11:20:02 +0800
X-Google-Sender-Auth: F7l3gMBqmafNYQdru9pVtYh8FQk
Message-ID: <CAFiDJ5_hjBQ4tOpsUdgqgwRrJ1TgFSa9pEqc2m+srMj5Fkir=w@mail.gmail.com>
Subject: Re: [PATCH v2 21/29] nios2: Futex operations
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 5:55 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 July 2014 11:42:34 Thomas Gleixner wrote:
>> On Fri, 18 Jul 2014, Arnd Bergmann wrote:
>> > On Friday 18 July 2014 14:07:42 Ley Foon Tan wrote:
>> > > On Thu, Jul 17, 2014 at 7:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > If this understanding is right, we can probably just merge the
>> > m68k implementation into the asm-generic version, as that does
>> > exactly that, and just isn't SMP safe. I'm still unsure whether
>> > I'm missing something here though, as everything else seems to
>> > do this in assembly, even for non-SMP machines that could use
>> > the trivial method that m68k has.
>>
>> For UP relying of pagefault disable should be good enough indeed. I
>> guess the asm for the other UP stuff results from looking at
>> architectures or copying from architectures which did this in ASM
>
> Ok, thanks for the confirmation!
>
> Ley Foon Tan, I think the best way forward then is for you to
> take the m68k code and copy (or move) that into asm-generic/futex.h
> under an #ifndef CONFIG_SMP.

Okay, I will copy m68k implementation to asm-generic/futex.h.
Do you prefer this as separate patch submission or this can be part of
nios2 patchset?
Thanks.

Regards
Ley Foon
