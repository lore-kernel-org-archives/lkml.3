Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3GOShT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:37:19 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:46392 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3GOShR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:37:17 -0400
MIME-Version: 1.0
In-Reply-To: <51E43ACD.9080307@zytor.com>
References: <20130712225017.GA5366@www.outflux.net>
	<tip-c0b3450f101523a49823fa93d155f1d258e5ac6f@git.kernel.org>
	<CAE9FiQXvfopU1SYs3OFQk8rXVgq-Hbhw6gB49u5H4O70Tx12+A@mail.gmail.com>
	<51E43ACD.9080307@zytor.com>
Date: Mon, 15 Jul 2013 11:37:16 -0700
X-Google-Sender-Auth: w13rm-sMD7QQYNEZ7RNMhyc8MRM
Message-ID: <CAGXu5jJOJTb_rd5gqZ8Omz=0V=jwONk8BRCzQN6jqO1fO6DfQg@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86: Make sure IDT is page aligned
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pageexec@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 15, 2013 at 11:09 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/13/2013 02:34 PM, Yinghai Lu wrote:
>>
>> can we use put all idt_table related in to __bss.aligned section ...?
>>
>> like
>> gate_desc idt_table[NR_VECTORS] __page_aligned_bss;
>>
>
> I think this is the best solution all around... it not only solves the
> initializer problem but also reduces the size of data.
>
> A long, long time ago in a galaxy far, far away I believe the IDT got
> set up before we cleared bss, but that is no longer the case as we now
> clear bss very, very early (on 32 bits before paging is even enabled.)
>
> Still, it would seem that the minimal solution, if we need something for
> 3.11/stable, is to simply fix the alignment statement in head_64.S
> (optionally move to .bss..page_aligned) and then do the proper cleanup
> for 3.12.  If you could prepare a patch for the former (please include
> the descriptions we discussed over IRC) and a patchset for the latter it
> would be good.

Sorry for the trouble I caused on this. I've reorganized how I do test
builds now, which should hopefully cut down on my stupid mistakes.

I'll send two patches, one for 3.11/stable with the absolute minimal
change to alignment, and another for 3.12 that moves all the IDT
variables into common places using __page_aligned_bss as Yinghai Lu
recommended.

Thanks,

-Kees


--
Kees Cook
Chrome OS Security
