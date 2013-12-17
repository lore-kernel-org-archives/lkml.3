Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab3LQPFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:05:55 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:63378 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab3LQPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:05:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131011124551.GF2917@hansolo.jdub.homelinux.org>
References: <20131011124551.GF2917@hansolo.jdub.homelinux.org>
Date: Tue, 17 Dec 2013 10:05:53 -0500
X-Google-Sender-Auth: U4rhSab0oecm4vPhoxNeHfQt9p0
Message-ID: <CA+5PVA7k8F8tEOz1p4O1Mh9xP3xuixPrwYtPQfvA3o7mmwb_MA@mail.gmail.com>
Subject: Re: [PATCH] cpupower: Fix segfault due to incorrect getopt_long arugments
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 8:45 AM, Josh Boyer <jwboyer@redhat.com> wrote:
> If a user calls 'cpupower set --perf-bias 15', the process will end with a
> SIGSEGV in libc because cpupower-set passes a NULL optarg to the atoi call.
> This is because the getopt_long structure currently has all of the options
> as having an optional_argument when they really have a required argument.
> We change the structure to use required_argument to match the short options
> and it resolves the issue.
>
> This fixes https://bugzilla.redhat.com/show_bug.cgi?id=1000439
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

Ping?  I sent this 2 months ago and never got a reply.  We're still
carrying it in Fedora.

josh

> ---
>  tools/power/cpupower/utils/cpupower-set.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/power/cpupower/utils/cpupower-set.c b/tools/power/cpupower/utils/cpupower-set.c
> index dc4de37..bcf1d2f 100644
> --- a/tools/power/cpupower/utils/cpupower-set.c
> +++ b/tools/power/cpupower/utils/cpupower-set.c
> @@ -18,9 +18,9 @@
>  #include "helpers/bitmask.h"
>
>  static struct option set_opts[] = {
> -       { .name = "perf-bias",  .has_arg = optional_argument,   .flag = NULL,   .val = 'b'},
> -       { .name = "sched-mc",   .has_arg = optional_argument,   .flag = NULL,   .val = 'm'},
> -       { .name = "sched-smt",  .has_arg = optional_argument,   .flag = NULL,   .val = 's'},
> +       { .name = "perf-bias",  .has_arg = required_argument,   .flag = NULL,   .val = 'b'},
> +       { .name = "sched-mc",   .has_arg = required_argument,   .flag = NULL,   .val = 'm'},
> +       { .name = "sched-smt",  .has_arg = required_argument,   .flag = NULL,   .val = 's'},
>         { },
>  };
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
