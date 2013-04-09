Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556Ab3DIEhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 00:37:55 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:55029 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3DIEhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 00:37:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130408144341.4da5f848358f0cfaba964bd7@linux-foundation.org>
References: <1365329658.27045.6.camel@beeld>
	<20130408144341.4da5f848358f0cfaba964bd7@linux-foundation.org>
Date: Tue, 9 Apr 2013 10:37:53 +0600
Message-ID: <CADZ9YHiXTUb5o1xiZdqhv-pwdto1zV61W+uUiK5jw=nJ0HrJvw@mail.gmail.com>
Subject: Re: [PATCH] auditsc: Use kzalloc instead of kmalloc+memset.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 3:43 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Fair enough.  I'd go futher...
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: auditsc-use-kzalloc-instead-of-kmallocmemset-fix
>
> remove audit_set_context() altogether - fold it into its caller
>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Rakib Mullick <rakib.mullick@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/auditsc.c |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
>
> diff -puN kernel/auditsc.c~auditsc-use-kzalloc-instead-of-kmallocmemset-fix kernel/auditsc.c
> --- a/kernel/auditsc.c~auditsc-use-kzalloc-instead-of-kmallocmemset-fix
> +++ a/kernel/auditsc.c
> @@ -1034,13 +1034,6 @@ static inline void audit_free_aux(struct
>         }
>  }
>
> -static inline void audit_set_context(struct audit_context *context,
> -                                     enum audit_state state)
> -{
> -       context->state      = state;
> -       context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
> -}
> -
>  static inline struct audit_context *audit_alloc_context(enum audit_state state)
>  {
>         struct audit_context *context;
> @@ -1048,7 +1041,8 @@ static inline struct audit_context *audi
>         context = kzalloc(sizeof(*context), GFP_KERNEL);
>         if (!context)
>                 return NULL;
> -       audit_set_context(context, state);
> +       context->state = state;
> +       context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
>         INIT_LIST_HEAD(&context->killed_trees);
>         INIT_LIST_HEAD(&context->names_list);
>         return context;
> _
>
Yes, this one is better than my patch and it's due to its diff stat.

Thanks,
Rakib.
