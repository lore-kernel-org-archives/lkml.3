Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3CYLNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:13:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52529 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3CYLNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:13:45 -0400
Message-ID: <1364210014.5053.2.camel@laptop>
Subject: Re: [PATCH v5 1/2] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Date: Mon, 25 Mar 2013 12:13:34 +0100
In-Reply-To: <1363949499-3728-2-git-send-email-eranian@google.com>
References: <1363949499-3728-1-git-send-email-eranian@google.com>
	 <1363949499-3728-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 11:51 +0100, Stephane Eranian wrote:
> +#define PERF_CPU_HRTIMER (1000 / HZ)
> +static enum hrtimer_restart perf_cpu_hrtimer_handler(struct hrtimer
> *hr)
> +{
> +       struct perf_cpu_context *cpuctx;
> +       enum hrtimer_restart ret = HRTIMER_NORESTART;
> +       unsigned long flags;
> +       int rotations = 0;
> +
> +       cpuctx = container_of(hr, struct perf_cpu_context, hrtimer);
> +
> +       local_irq_save(flags);
> +
> +       rotations = perf_rotate_context(cpuctx);
> +
> +       local_irq_restore(flags);

IIRC hrtimer callbacks are always ran with interrupts disabled.. not a
big deal though. I'll continue reading.

