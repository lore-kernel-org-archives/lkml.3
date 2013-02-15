Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936055Ab3BOQSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:18:32 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35877 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab3BOQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:18:30 -0500
MIME-Version: 1.0
In-Reply-To: <1360943688-12502-1-git-send-email-paul.gortmaker@windriver.com>
References: <1360943688-12502-1-git-send-email-paul.gortmaker@windriver.com>
Date: Fri, 15 Feb 2013 08:18:29 -0800
X-Google-Sender-Auth: AHujPFl7vfGsjDPt0_FfAQx4KdE
Message-ID: <CAGXu5jJxPU2Skr12u07fTeg+8im6L4JHv23+TrB+qVWMY36F_w@mail.gmail.com>
Subject: Re: [PATCH] futex: avoid kernel taint caused by get_robust_list
From: Kees Cook <keescook@chromium.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 7:54 AM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> commit ec0c4274e33c0373e476b73e01995c53128f1257 ("futex: Mark
> get_robust_list as deprecated") added these two WARN_ONCE calls.
>
> However, WARN_ONCE taints the kernel, and we shouldn't be allowing
> any user who wanders by to do this.  For example, the system fuzzer
> "trinity" uses the tainted state as a metric for when to stop,
> assuming that it has caused significant wreckage (and indeed
> that tool is what actually led me to this change).
>
> The ability to deprecate this code has been called into question[1],
> but if that remains to be finalized, then making this change in the
> interim seems to make sense.
>
> [1] http://lkml.indiana.edu/hypermail/linux/kernel/1208.0/01081.html
>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org      # 3.4+
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

I Acked the original revert. I thought there was agreement that it was
needed for checkpointing to work?

-Kees

-- 
Kees Cook
Chrome OS Security
