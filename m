Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaDAWyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:54:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60640 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaDAWyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:54:45 -0400
Message-ID: <533B43B2.1020805@codeaurora.org>
Date: Tue, 01 Apr 2014 15:54:42 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Larry Bassel <lbassel@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
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
Subject: Re: [PATCH 2/2] ARM: mm: keep rodata non-executable
References: <1392339850-18686-1-git-send-email-keescook@chromium.org> <1392339850-18686-3-git-send-email-keescook@chromium.org> <20140214162257.GB2331@e103592.cambridge.arm.com> <CAGXu5jLmYLQpu9CDhoL-2OTdwxqrfVCFbojmpjpcpLqmA=wWYA@mail.gmail.com> <20140217123415.GA2182@e103592.cambridge.arm.com> <532F2C48.6050509@codeaurora.org> <CAGXu5jK_8adL=6DoF9gFBMWxKcxKUHw7238ighE2agFU7cqhWg@mail.gmail.com> <1395658064.3465.7.camel@linaro1.home> <CAGXu5jLEA5u58yNe0k4BobWphAhEiREJ1ped30LVgDRPzOGy7A@mail.gmail.com>
In-Reply-To: <CAGXu5jLEA5u58yNe0k4BobWphAhEiREJ1ped30LVgDRPzOGy7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/2014 3:34 PM, Kees Cook wrote:
> On Mon, Mar 24, 2014 at 3:47 AM, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
>> On Sun, 2014-03-23 at 16:21 -0600, Kees Cook wrote:
>>> For this stage, how about I make this "depends on KEXEC=n &&
>>> KPROBES=n"?
>>
>> There's also ftrace (CONFIG_DYNAMIC_FTRACE I believe) which modifies
>> kernel code with a call to probe_kernel_write(), which GDB uses as well.
>>
>> And grepping for the patch_text() function also shows
>> __arch_jump_label_transform() modifies kernel code. Not sure how and
>> when that gets used.
> 
> Right, so, I'm trying to fix ftrace now, and I've hit a wall. It is as
> if changes to the kernel text PMD aren't being noticed after the
> kernel is running. Does anyone know why this might be happening?
> 
> Code and details here:
> https://lkml.org/lkml/2014/4/1/674
> 
> -Kees
> 

We had a flush_tlb_kernel_page after the pmd_flush in our out of tree code
which makes the text writeable in __patch_text.

Laura

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
