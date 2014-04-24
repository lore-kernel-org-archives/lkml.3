Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaDXGmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:42:52 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:41055 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbaDXGmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:42:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140422143036.GD15745@arch.cereza>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-6-git-send-email-lftan@altera.com>
	<20140422143036.GD15745@arch.cereza>
Date: Thu, 24 Apr 2014 14:42:49 +0800
X-Google-Sender-Auth: 6y4GkdAZjuuAIeUBVLL1vjrBJpo
Message-ID: <CAFiDJ59KHkh549PBezijr-UektFQtQaZ_5fP5qqRvsVC-e2uxw@mail.gmail.com>
Subject: Re: [PATCH 08/28] nios2: MMU Fault handling
From: Ley Foon Tan <lftan@altera.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:30 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> Hello Ley Foon,
>
> On Apr 18, Ley Foon Tan wrote:
>> +
>> +bad_area_nosemaphore:
>> +     /* User mode accesses just cause a SIGSEGV */
>> +     if (user_mode(regs)) {
>
> I found that it's useful to add some printing here, just as ARM
> does. I carry this patch on my kernel:
>
> +               printk(KERN_INFO "%s: unhandled page fault (%d) at 0x%08lx, cause %ld\n",
> +                      current->comm, SIGSEGV, address, cause);
> +               show_regs(regs);
>
> Do you think we could do something like it? Maybe with a compile time option?
Yes, this is useful debug message. I can add this.
Prefer not to add new compile time option, I think this shouldn't
happen frequently.
>
>> +             _exception(SIGSEGV, regs, code, address);
>> +             return;
>> +     }
>> +
