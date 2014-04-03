Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaDCXO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:14:56 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64716 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaDCXOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAH+eYFDkYczZXYF3be6tTRg7kkGhK2zyukDTo+N8mwEKcG89LA@mail.gmail.com>
References: <1396346657-7166-1-git-send-email-holler@ahsoftware.de>
	<533AFF77.5030106@codeaurora.org>
	<CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com>
	<CAH+eYFDkYczZXYF3be6tTRg7kkGhK2zyukDTo+N8mwEKcG89LA@mail.gmail.com>
Date: Thu, 3 Apr 2014 16:14:54 -0700
X-Google-Sender-Auth: DCN9_v_5wEGYTjf77c-Rc_5Ge2o
Message-ID: <CAGXu5jKyzbRR4S0+0daygWcE2-BbFi1X6MFAkPqTNbGiT6huSQ@mail.gmail.com>
Subject: Re: [PATCH] arm: don't allow CONFIG_DEBUG_SET_MODULE_RONX if
 CONFIG_JUMP_LABEL is enabled
From: Kees Cook <keescook@chromium.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 4:08 PM, Rabin Vincent <rabin@rab.in> wrote:
> 2014-04-01 20:36 GMT+02:00 Kees Cook <keescook@chromium.org>:
>> Is there something "sticky" about PMD sections that I'm not aware of?
>> Even after calling set_kernel_text_rw(), any writes to kernel memory
>> fault. :(
>
> section_update() updates init_mm, but each mm has a copy of the first
> level page tables.  So your updates to init_mm won't be visibile to
> currently running processes.  (Have a look at arch/arm/mm/ioremap.c's
> vmalloc_seq stuff for some background on how section support is
> handled on non-SMP; the vmalloc code doesn't use sections on SMP.)

Ah-ha! This is the missing piece of information for me. :)

> Here's a patch (probably whitespace damaged, hence also attached) with
> which dynamic ftrace works for me on top your other paches.  Tested on
> a non-LPAE SMP.

Thanks! I'll incorporate calls to set_all_modules_text_rw/ro and see
what I can make work.

-Kees

-- 
Kees Cook
Chrome OS Security
