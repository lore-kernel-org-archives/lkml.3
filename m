Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3CAF6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:58:55 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62730 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3CAF6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:58:54 -0500
MIME-Version: 1.0
In-Reply-To: <1362101815-19968-1-git-send-email-yong.zhang0@gmail.com>
References: <1362101815-19968-1-git-send-email-yong.zhang0@gmail.com>
Date: Fri, 1 Mar 2013 13:58:52 +0800
Message-ID: <CAM2zO=A8UvTizpHWmkaxH+nT+yusmFFKagq3BNDAQ+XB0EBxhw@mail.gmail.com>
Subject: Re: [PATCH] futex: fix unbalanced spin_lock/spin_unlock() in exit_pi_state_list()
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 9:36 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -562,16 +562,17 @@ void exit_pi_state_list(struct task_struct *curr)
>
>                 spin_lock(&hb->lock);
>
> -               raw_spin_lock_irq(&curr->pi_lock);
>                 /*
>                  * We dropped the pi-lock, so re-check whether this
>                  * task still owns the PI-state:
>                  */
>                 if (head->next != next) {

Just ignore this patch, race window is opened here.
New patch comes soon.

Thanks,
Yong

>                         spin_unlock(&hb->lock);
> +                       raw_spin_lock_irq(&curr->pi_lock);
>                         continue;
>                 }
>
> +               raw_spin_lock_irq(&curr->pi_lock);
>                 WARN_ON(pi_state->owner != curr);
>                 WARN_ON(list_empty(&pi_state->list));
>                 list_del_init(&pi_state->list);
> --
> 1.7.9.5
>



-- 
Only stand for myself
