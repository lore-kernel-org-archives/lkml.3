Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaDAWeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:34:06 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62095 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaDAWeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <1395658064.3465.7.camel@linaro1.home>
References: <1392339850-18686-1-git-send-email-keescook@chromium.org>
	<1392339850-18686-3-git-send-email-keescook@chromium.org>
	<20140214162257.GB2331@e103592.cambridge.arm.com>
	<CAGXu5jLmYLQpu9CDhoL-2OTdwxqrfVCFbojmpjpcpLqmA=wWYA@mail.gmail.com>
	<20140217123415.GA2182@e103592.cambridge.arm.com>
	<532F2C48.6050509@codeaurora.org>
	<CAGXu5jK_8adL=6DoF9gFBMWxKcxKUHw7238ighE2agFU7cqhWg@mail.gmail.com>
	<1395658064.3465.7.camel@linaro1.home>
Date: Tue, 1 Apr 2014 15:34:02 -0700
X-Google-Sender-Auth: bLNujuhjoV2rPJhyqIMpoyJTrwE
Message-ID: <CAGXu5jLEA5u58yNe0k4BobWphAhEiREJ1ped30LVgDRPzOGy7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: mm: keep rodata non-executable
From: Kees Cook <keescook@chromium.org>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Laura Abbott <lauraa@codeaurora.org>,
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
        Jonathan Austin <jonathan.austin@arm.com>,
        Simon Baatz <gmbnomis@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 3:47 AM, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
> On Sun, 2014-03-23 at 16:21 -0600, Kees Cook wrote:
>> For this stage, how about I make this "depends on KEXEC=n &&
>> KPROBES=n"?
>
> There's also ftrace (CONFIG_DYNAMIC_FTRACE I believe) which modifies
> kernel code with a call to probe_kernel_write(), which GDB uses as well.
>
> And grepping for the patch_text() function also shows
> __arch_jump_label_transform() modifies kernel code. Not sure how and
> when that gets used.

Right, so, I'm trying to fix ftrace now, and I've hit a wall. It is as
if changes to the kernel text PMD aren't being noticed after the
kernel is running. Does anyone know why this might be happening?

Code and details here:
https://lkml.org/lkml/2014/4/1/674

-Kees

-- 
Kees Cook
Chrome OS Security
