Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaC1MYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 08:24:39 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:45768 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaC1MYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:24:38 -0400
MIME-Version: 1.0
In-Reply-To: <c2108011e02e39d0be889be658046e0de44f7c79.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
	<c2108011e02e39d0be889be658046e0de44f7c79.1396006658.git.viresh.kumar@linaro.org>
Date: Fri, 28 Mar 2014 17:54:38 +0530
Message-ID: <CAKohpomTFiVWVs6WtoiaHs37SBbHw_g=_mED_RwxdUronU8bDQ@mail.gmail.com>
Subject: Re: [PATCH 16/16] hrtimer: use base->hres_active directly instead of hrtimer_hres_active()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2014 17:11, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> @@ -1107,7 +1107,7 @@ ktime_t hrtimer_get_next_event(void)
>
>         raw_spin_lock_irqsave(&cpu_base->lock, flags);
>
> -       if (!hrtimer_hres_active()) {
> +       if (!cpu_base->hres_active) {
>                 for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
>                         struct hrtimer *timer;
>                         struct timerqueue_node *next;
> @@ -1437,7 +1437,7 @@ void hrtimer_run_queues(void)
>         struct hrtimer_clock_base *base;
>         int index, gettime = 1;
>
> -       if (hrtimer_hres_active())
> +       if (cpu_base->hres_active)
>                 return;
>
>         for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {

These two changes are broken.. Would remove these and resend..
My tree is fixed though..
