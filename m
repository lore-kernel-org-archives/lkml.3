Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaKZRuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:50:20 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49504 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaKZRuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:50:18 -0500
MIME-Version: 1.0
In-Reply-To: <1417010419-3827-2-git-send-email-sasha.levin@oracle.com>
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
	<1417010419-3827-2-git-send-email-sasha.levin@oracle.com>
Date: Wed, 26 Nov 2014 21:50:15 +0400
Message-ID: <CAPAsAGztsLxPbYfLzmDmGUeezhs_q_Az=Q9oNHRqnpBXjAajjg@mail.gmail.com>
Subject: Re: [RFC 2/2] kvm: eventfd: detect integer overflow using check_*_overflow
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 17:00 GMT+03:00 Sasha Levin <sasha.levin@oracle.com>:
> Detect integer overflows using safe operations rather than relying on
> undefined behaviour.
>

Unsigned overflow is defined.
args->addr and args->len  both unsigned, so there is no UB here.

> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  virt/kvm/eventfd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 148b239..2eb044f 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -790,7 +790,7 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>         }
>
>         /* check for range overflow */
> -       if (args->addr + args->len < args->addr)
> +       if (check_add_overflow(args->len, args->addr))
>                 return -EINVAL;
>
>         /* check for extra flags that we don't understand */
> --
> 1.7.10.4
>
