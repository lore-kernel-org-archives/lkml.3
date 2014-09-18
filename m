Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbaIRQmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:42:13 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:36432 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbaIRQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:42:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140918154621.F16A2C86@viggo.jf.intel.com>
References: <20140918154621.F16A2C86@viggo.jf.intel.com>
Date: Thu, 18 Sep 2014 20:42:10 +0400
Message-ID: <CAPAsAGzSfW6ba5Bcij_ndVZ7M8fyQGWS7KO76NZDbifRbW-XNg@mail.gmail.com>
Subject: Re: [PATCH] x86: update memory map about hypervisor-reserved area
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Dave Hansen <dave@sr71.net>
Cc: LKML <linux-kernel@vger.kernel.org>, dave.hansen@linux.intel.com,
        Dmitry Vyukov <dvyukov@google.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-18 19:46 GMT+04:00 Dave Hansen <dave@sr71.net>:
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> Peter Anvin says:
>> 0xffff880000000000 is the lowest usable address because we have
>> agreed to leave 0xffff800000000000-0xffff880000000000 for the
>> hypervisor or other non-OS uses.
>
> Let's call this out in the documentation.
>
> This came up during the kernel address sanitizer discussions
> where it was proposed to use this area for other kernel things.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: x86@kernel.org
> Cc: linux-mm@kvack.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>
>  b/Documentation/x86/x86_64/mm.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -puN Documentation/x86/x86_64/mm.txt~update-x86-mm-doc Documentation/x86/x86_64/mm.txt
> --- a/Documentation/x86/x86_64/mm.txt~update-x86-mm-doc 2014-09-17 21:44:10.499781092 -0700
> +++ b/Documentation/x86/x86_64/mm.txt   2014-09-17 21:44:31.852740822 -0700
> @@ -5,7 +5,7 @@ Virtual memory map with 4 level page tab
>
>  0000000000000000 - 00007fffffffffff (=47 bits) user space, different per mm
>  hole caused by [48:63] sign extension
> -ffff800000000000 - ffff80ffffffffff (=40 bits) guard hole
> +ffff800000000000 - ffff80ffffffffff (=40 bits) guard hole, reserved for hypervisor

ffff800000000000 - ffff87ffffffffff (=43 bits) guard hole, reserved
for hypervisor

>  ffff880000000000 - ffffc7ffffffffff (=64 TB) direct mapping of all phys. memory
>  ffffc80000000000 - ffffc8ffffffffff (=40 bits) hole
>  ffffc90000000000 - ffffe8ffffffffff (=45 bits) vmalloc/ioremap space
> _



-- 
Best regards,
Andrey Ryabinin
