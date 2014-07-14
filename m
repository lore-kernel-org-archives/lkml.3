Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844AbaGNTjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:39:04 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58537 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaGNTjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:39:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140714003105.GA1333@archDesk>
References: <20140714003105.GA1333@archDesk>
From: Lucas Tanure <tanure@linux.com>
Date: Mon, 14 Jul 2014 16:38:43 -0300
X-Google-Sender-Auth: molIJPujzqCRdWrfi7yEDj9kTII
Message-ID: <CAJyon0szZAs1c_eXYS8-rJwParHNUxGs=CuFbDYkj5=t5gB9=w@mail.gmail.com>
Subject: Re: [PATCH v4] staging: android: Clean up else statement from binder_send_failed_reply
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch got accepted ?

Thanks
--
Lucas Tanure
+55 (19) 988176559


On Sun, Jul 13, 2014 at 9:31 PM, Lucas Tanure <tanure@linux.com> wrote:
> Kernel coding style. Remove useless else statement after return.
> Changes from v1 and v2: Fix warning for mixed declarations and code.
> Declaration of "struct binder_transaction *next" made outside of while.
>
> Changes from v3: Removed initialization to NULL for next variable.
>
> Signed-off-by: Lucas Tanure <tanure@linux.com>
> ---
>  drivers/staging/android/binder.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 14714a6..4f34dc0 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -1183,6 +1183,7 @@ static void binder_send_failed_reply(struct binder_transaction *t,
>                                      uint32_t error_code)
>  {
>         struct binder_thread *target_thread;
> +       struct binder_transaction *next;
>
>         BUG_ON(t->flags & TF_ONE_WAY);
>         while (1) {
> @@ -1210,24 +1211,23 @@ static void binder_send_failed_reply(struct binder_transaction *t,
>                                         target_thread->return_error);
>                         }
>                         return;
> -               } else {
> -                       struct binder_transaction *next = t->from_parent;
> +               }
> +               next = t->from_parent;
>
> -                       binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
> -                                    "send failed reply for transaction %d, target dead\n",
> -                                    t->debug_id);
> +               binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
> +                            "send failed reply for transaction %d, target dead\n",
> +                            t->debug_id);
>
> -                       binder_pop_transaction(target_thread, t);
> -                       if (next == NULL) {
> -                               binder_debug(BINDER_DEBUG_DEAD_BINDER,
> -                                            "reply failed, no target thread at root\n");
> -                               return;
> -                       }
> -                       t = next;
> +               binder_pop_transaction(target_thread, t);
> +               if (next == NULL) {
>                         binder_debug(BINDER_DEBUG_DEAD_BINDER,
> -                                    "reply failed, no target thread -- retry %d\n",
> -                                     t->debug_id);
> +                                    "reply failed, no target thread at root\n");
> +                       return;
>                 }
> +               t = next;
> +               binder_debug(BINDER_DEBUG_DEAD_BINDER,
> +                            "reply failed, no target thread -- retry %d\n",
> +                             t->debug_id);
>         }
>  }
>
> --
> 2.0.1
>
