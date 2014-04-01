Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaDAXAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:00:00 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51186 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaDAW76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:59:58 -0400
MIME-Version: 1.0
In-Reply-To: <533B43B2.1020805@codeaurora.org>
References: <1392339850-18686-1-git-send-email-keescook@chromium.org>
	<1392339850-18686-3-git-send-email-keescook@chromium.org>
	<20140214162257.GB2331@e103592.cambridge.arm.com>
	<CAGXu5jLmYLQpu9CDhoL-2OTdwxqrfVCFbojmpjpcpLqmA=wWYA@mail.gmail.com>
	<20140217123415.GA2182@e103592.cambridge.arm.com>
	<532F2C48.6050509@codeaurora.org>
	<CAGXu5jK_8adL=6DoF9gFBMWxKcxKUHw7238ighE2agFU7cqhWg@mail.gmail.com>
	<1395658064.3465.7.camel@linaro1.home>
	<CAGXu5jLEA5u58yNe0k4BobWphAhEiREJ1ped30LVgDRPzOGy7A@mail.gmail.com>
	<533B43B2.1020805@codeaurora.org>
Date: Tue, 1 Apr 2014 15:59:57 -0700
X-Google-Sender-Auth: 4nFcfWORaUXW-vcPgD6rxuJeDbQ
Message-ID: <CAGXu5jLhbUsfnuEULdcyMm_BxrggeMTH5-b6Bdv4eWkGvneWjw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: mm: keep rodata non-executable
From: Kees Cook <keescook@chromium.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Larry Bassel <lbassel@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>, Jiang Liu <liuj97@gmail.com>,
        Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 3:54 PM, Laura Abbott <lauraa@codeaurora.org> wrote:
> On 4/1/2014 3:34 PM, Kees Cook wrote:
>> On Mon, Mar 24, 2014 at 3:47 AM, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
>>> On Sun, 2014-03-23 at 16:21 -0600, Kees Cook wrote:
>>>> For this stage, how about I make this "depends on KEXEC=n &&
>>>> KPROBES=n"?
>>>
>>> There's also ftrace (CONFIG_DYNAMIC_FTRACE I believe) which modifies
>>> kernel code with a call to probe_kernel_write(), which GDB uses as well.
>>>
>>> And grepping for the patch_text() function also shows
>>> __arch_jump_label_transform() modifies kernel code. Not sure how and
>>> when that gets used.
>>
>> Right, so, I'm trying to fix ftrace now, and I've hit a wall. It is as
>> if changes to the kernel text PMD aren't being noticed after the
>> kernel is running. Does anyone know why this might be happening?
>>
>> Code and details here:
>> https://lkml.org/lkml/2014/4/1/674
>>
>> -Kees
>>
>
> We had a flush_tlb_kernel_page after the pmd_flush in our out of tree code
> which makes the text writeable in __patch_text.

I tried flush_tlb_kernel_range(), which I'd expect to do the same
thing. I can try with _page() too.

-Kees

-- 
Kees Cook
Chrome OS Security
