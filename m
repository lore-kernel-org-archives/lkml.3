Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaGNRQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:16:25 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33271 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaGNRQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:16:19 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrU44CM5=hSOMQGB6eEM2g-h6y5_+-SwoMwu+-qp-Pxd7g@mail.gmail.com>
References: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com>
 <53C40D83.3090501@zytor.com> <CALCETrU44CM5=hSOMQGB6eEM2g-h6y5_+-SwoMwu+-qp-Pxd7g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 14 Jul 2014 10:15:57 -0700
Message-ID: <CALCETrVz7a7RVLhYTrGvHkJR2dGHJbRuATOaWaXgkrSABR7YFA@mail.gmail.com>
Subject: Re: Is espfix64's double-fault thing OK on Xen?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:11 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Mon, Jul 14, 2014 at 10:04 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/09/2014 04:17 PM, Andy Lutomirski wrote:
>>> This part in __do_double_fault looks fishy:
>>>
>>>     cmpl $__KERNEL_CS,CS(%rdi)
>>>     jne do_double_fault
>>>
>>> Shouldn't that be:
>>>
>>>     test $3,CS(%rdi)
>>>     jnz do_double_fault
>>>
>>
>> No, it should be fine.  The *only* case where we need to do the espfix
>> magic is when we are on __KERNEL_CS.
>>
>
> IIRC Xen has a somewhat different GDT, and at least the userspace CS
> in IA32_STAR disagrees with normal Linux.  If the kernel CS is also
> strange, then there will be an extra possible CS value here.

There's FLAT_KERNEL_CS64, which is not equal to __KERNEL_CS.  If the
espfix mechanism gets invoked with that CS, then I expect that
something unexpected will happen.

That being said, FLAT_KERNEL_CS64 is CPL3, so my code might not be any better.

--Andy
