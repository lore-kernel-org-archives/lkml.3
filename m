Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623Ab3EBWvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 18:51:49 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:36102 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761233Ab3EBWvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 18:51:48 -0400
MIME-Version: 1.0
In-Reply-To: <1367325415-32283-1-git-send-email-prarit@redhat.com>
References: <1367325415-32283-1-git-send-email-prarit@redhat.com>
Date: Thu, 2 May 2013 15:51:47 -0700
Message-ID: <CA+8MBbJP5DDvRMfTmTEw==G56Ghow2o61CKs15PyURt6+FbNHA@mail.gmail.com>
Subject: Re: [PATCH] NOHZ, check to see if tick device is initialized in IRQ
 handling path
From: Tony Luck <tony.luck@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  void tick_nohz_irq_exit(void)
>  {
>         struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
> +       struct clock_event_device *dev =
> +                                    __get_cpu_var(tick_cpu_device).evtdev;
> +
> +       /* Has the tick been initialized yet? */
> +       if (unlikely(!dev || dev->mode == CLOCK_EVT_MODE_UNUSED))
> +               return;

Could we have something in the "struct tick_sched" to tell us whether
it has been set up? Rather than this somewhat convoluted digging
around in the clock_event_device innards?

> +       if (unlikely(!dev || dev->mode == CLOCK_EVT_MODE_UNUSED))
> +               return;

Ditto here.

-Tony
