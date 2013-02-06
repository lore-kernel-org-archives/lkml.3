Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab3BFW72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:59:28 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35239 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758157Ab3BFW6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:58:48 -0500
MIME-Version: 1.0
In-Reply-To: <1360186160-7566-1-git-send-email-dbaluta@ixiacom.com>
References: <1360186160-7566-1-git-send-email-dbaluta@ixiacom.com>
Date: Wed, 6 Feb 2013 23:58:46 +0100
Message-ID: <CAFTL4hy=hv_ey-_2gMKtW=pd7r+X6PP5cQ6_sHzsLUYqeFV5Tg@mail.gmail.com>
Subject: Re: [PATCH] perf/hwbp: Fix cleanup in case of kzalloc failure
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Daniel Baluta <dbaluta@ixiacom.com>, Ingo Molnar <mingo@kernel.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/6 Daniel Baluta <dbaluta@ixiacom.com>:
> Obviously this is a typo and could result in memory leaks
> if kzalloc fails on a given cpu.
>
> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>

Good catch!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> ---
>  kernel/events/hw_breakpoint.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index fe8a916..a64f8ae 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -676,7 +676,7 @@ int __init init_hw_breakpoint(void)
>   err_alloc:
>         for_each_possible_cpu(err_cpu) {
>                 for (i = 0; i < TYPE_MAX; i++)
> -                       kfree(per_cpu(nr_task_bp_pinned[i], cpu));
> +                       kfree(per_cpu(nr_task_bp_pinned[i], err_cpu));
>                 if (err_cpu == cpu)
>                         break;
>         }
> --
> 1.7.5.4
>
