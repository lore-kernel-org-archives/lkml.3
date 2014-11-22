Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaKVBfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 20:35:14 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:58797 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaKVBfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 20:35:12 -0500
MIME-Version: 1.0
In-Reply-To: <20141121095037.2f5a4d4f@gandalf.local.home>
References: <20141121095037.2f5a4d4f@gandalf.local.home>
Date: Fri, 21 Nov 2014 17:35:10 -0800
X-Google-Sender-Auth: Y-7rWDanNcuO31_f6WWY8JY9Bn0
Message-ID: <CA+55aFx3AZpdU2YxFrNXvhWqJ2PyhyQBqTi7v_9hGH1UV-aY4g@mail.gmail.com>
Subject: Re: [GIT PULL] ftrace/x86: Add frames pointers to trampoline as necessary
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 6:50 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> +.macro create_frame parent rip
> +#ifdef CC_USING_FENTRY
> +       pushq \parent
> +       pushq %rbp
> +       movq %rsp, %rbp

This is a very strange frame.

Why do you do the "pushq \parent" at all? Why isn't this just a *real*
frame and add it to MCOUNT_SAVE_FRAME.

You seem to create this fake frame-within-a-frame thing. It's not clear why.

                  Linus
