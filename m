Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaHSCOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 22:14:15 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:62579 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbaHSCOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 22:14:14 -0400
MIME-Version: 1.0
In-Reply-To: <53F16F62.2090902@windriver.com>
References: <1408011216-8621-1-git-send-email-kpark3469@gmail.com>
	<87lhqp8uvu.fsf@rustcorp.com.au>
	<53F16F62.2090902@windriver.com>
Date: Tue, 19 Aug 2014 11:14:13 +0900
Message-ID: <CA+KhAHYDAkXvZYW=ORdqoy3PDBAC+wi9K5qC=7qPkVbZ97N=6g@mail.gmail.com>
Subject: Re: [PATCH] earlyprintk: re-enable earlyprintk calling early_param
From: Keun-O Park <kpark3469@gmail.com>
To: Sahara <keun-o.park@windriver.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, hpa <hpa@zytor.com>,
        "rafael.j.wysocki" <rafael.j.wysocki@intel.com>,
        peterz <peterz@infradead.org>,
        "kirill.shutemov" <kirill.shutemov@linux.intel.com>,
        oleg <oleg@redhat.com>, prarit <prarit@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI only if you missed my previous 2 replies which didn't reach the
mailing list.
Thanks.



On Mon, Aug 18, 2014 at 12:13 PM, Sahara <keun-o.park@windriver.com> wrote:
>
> 2014년 08월 16일 03:34, Rusty Russell 쓴 글:
>
>> kpark3469@gmail.com writes:
>>>
>>> From: Sahara <keun-o.park@windriver.com>
>>>
>>> Although there are many obs_kernel_param and its names are
>>> earlyprintk and also EARLY_PRINTK is also enabled, we could not
>>> see the early_printk output properly until now. This patch
>>> considers earlycon as well as earlyprintk.
>>
>> Hmm, the initial "earlycon" hack slipped in when I wasn't looking.
>> I don't think we should extend it.
>>
>> Why not make the thing(s) you want early_param()s?
>>
>> Cheers,
>> Rusty.
>
> The earlycon and the earlyprintk are scattered and used in many
> architectures.
> It looks earlycon just could be a subset of earlyprintk.
> The earlycon is for uart specific, while the earlyprintk is to support vga,
> efi, xen, serial, and so on. Especially ARM uses earlyprintk in many places.
> And, I am not sure if this is a good chance to replace all the earlyprintk
> with the earlycon. As of now, it's fair for both earlycon and earlyprintk.
> Or perhaps removing case#2, see in my previous email to Andrew Morton, is
> better?, so users be forced to specify earlycon and earlyprintk in cmdline
> if they want to see early_printk() output.
>
> Thanks.
>
> Best Regards,
> Sahara.
>
>
>>
>>> --- a/init/main.c
>>> +++ b/init/main.c
>>> @@ -426,7 +426,8 @@ static int __init do_early_param(char *param, char
>>> *val, const char *unused)
>>>         for (p = __setup_start; p < __setup_end; p++) {
>>>                 if ((p->early && parameq(param, p->str)) ||
>>>                     (strcmp(param, "console") == 0 &&
>>> -                    strcmp(p->str, "earlycon") == 0)
>>> +                    ((strcmp(p->str, "earlycon") == 0) ||
>>> +                    (strcmp(p->str, "earlyprintk") == 0)))
>>>                 ) {
>>>                         if (p->setup_func(val) != 0)
>>>                                 pr_warn("Malformed early option '%s'\n",
>>> param);
>>> --
>>> 1.7.9.5
>
>
