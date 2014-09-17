Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaIQA2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 20:28:07 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63626 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaIQA2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 20:28:05 -0400
MIME-Version: 1.0
In-Reply-To: <1410912351-31273-1-git-send-email-rlarocque@google.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Sep 2014 17:27:42 -0700
Message-ID: <CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
To: Richard Larocque <rlarocque@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, filbranden@google.com, md@google.com,
        gthelen@google.com, X86 ML <x86@kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 5:05 PM, Richard Larocque <rlarocque@google.com> wrote:
> Adds new prctl calls to enable or disable VDSO loading for a process
> and its children.
>
> The PR_SET_DISABLE_VDSO call takes one argument, which is interpreted as
> a boolean value.  If true, it disables the loading of the VDSO on exec()
> for this process and any children created after this call.  A false
> value unsets the flag.
>
> The PR_GET_DISABLE_VDSO option returns a non-negative true value if VDSO
> loading has been disabled for this process, zero if it has not been
> disabled, and a negative value in case of error.
>
> These prctl calls are hidden behind a new Kconfig,
> CONFIG_VDSO_DISABLE_PRCTL.  This feature is available only on x86.
>
> The command line option vdso=0 overrides the behavior of
> PR_SET_DISABLE_VDSO, however, PR_GET_DISABLE_VDSO will coninue to return
> whetever setting was last set with PR_SET_DISABLE_VDSO.
>
> Signed-off-by: Richard Larocque <rlarocque@google.com>
> ---
> This patch is part of some work to better handle times and CRIU migration.
> I suspect that there are other use cases out there, so I'm offering this
> patch separately.
>
> When considering CRIU migration and times, we put some thought into how
> to handle the rdtsc instruction.  If we migrate between machines or across
> reboots, the migrated process will see values that could break its assumptions
> about how rdtsc is supposed to work.

I don't get it.

If __vdso_clock_gettime returns the wrong value in any scenario, we
should fix that.  Simiarly, CRIU *already works*, unless there's
something I don't know of.

That being said, I would like an option to gate off RDTSC for a
process and its children in order to make PR_TSC_SIGSEGV more useful.
All the prerequisites are there now.

What problem are you trying to solve exactly?

--Andy
