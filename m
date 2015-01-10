Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbbAJWH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:07:26 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:33297 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbbAJWHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:07:25 -0500
MIME-Version: 1.0
In-Reply-To: <1420927210-19738-4-git-send-email-dvlasenk@redhat.com>
References: <1420927210-19738-1-git-send-email-dvlasenk@redhat.com>
	<1420927210-19738-4-git-send-email-dvlasenk@redhat.com>
Date: Sat, 10 Jan 2015 14:07:24 -0800
X-Google-Sender-Auth: 1cMoa9M26Frb9Jvw0DzstX7xND8
Message-ID: <CA+55aFx54dhF7mU6NUTuCW2gP2XQt55XG-a3iDttSmijmdzbyw@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 2:00 PM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
> +       pushq_cfi %rdi
> +       CFI_REL_OFFSET rdi, 0
> +       pushq_cfi %rsi
> +       CFI_REL_OFFSET rsi, 0
> +       pushq_cfi %rdx
> +       CFI_REL_OFFSET rdx, 0
..
Ugh.

This is too ugly, it needs to die.

Why doesn't pushq_cfi do that CFI_REL_OFFSET thing?

And if there is some good reason why, then please let's just make sure
that there is a sane way to write pushes and pops, without having that
insane CFI crap for every single damn case.

Because this is unreadable.

                       Linus
