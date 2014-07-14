Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbaGNRLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:11:39 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:48634 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbaGNRLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <53C40D83.3090501@zytor.com>
References: <CALCETrXrVNKNQtxncfOth5OqaSOC7KygerbB-+QQb4_VKESVsA@mail.gmail.com>
 <53C40D83.3090501@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 14 Jul 2014 10:11:13 -0700
Message-ID: <CALCETrU44CM5=hSOMQGB6eEM2g-h6y5_+-SwoMwu+-qp-Pxd7g@mail.gmail.com>
Subject: Re: Is espfix64's double-fault thing OK on Xen?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:04 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/09/2014 04:17 PM, Andy Lutomirski wrote:
>> This part in __do_double_fault looks fishy:
>>
>>     cmpl $__KERNEL_CS,CS(%rdi)
>>     jne do_double_fault
>>
>> Shouldn't that be:
>>
>>     test $3,CS(%rdi)
>>     jnz do_double_fault
>>
>
> No, it should be fine.  The *only* case where we need to do the espfix
> magic is when we are on __KERNEL_CS.
>

IIRC Xen has a somewhat different GDT, and at least the userspace CS
in IA32_STAR disagrees with normal Linux.  If the kernel CS is also
strange, then there will be an extra possible CS value here.

--Andy
