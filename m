Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3KTUYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:24:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:5987 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755150Ab3KTUYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:24:03 -0500
Date: Wed, 20 Nov 2013 15:23:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com
Subject: Re: [PATCH 03/14] sched: SCHED_DEADLINE structures &
 implementation.
Message-ID: <20131120152358.2a6abfc3@gandalf.local.home>
In-Reply-To: <1383831828-15501-4-git-send-email-juri.lelli@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
	<1383831828-15501-4-git-send-email-juri.lelli@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Nov 2013 14:43:37 +0100
Juri Lelli <juri.lelli@gmail.com> wrote:


> +/*
> + * This function validates the new parameters of a -deadline task.
> + * We ask for the deadline not being zero, and greater or equal
> + * than the runtime.
> + */
> +static bool
> +__checkparam_dl(const struct sched_param2 *prm)
> +{
> +	return prm && (&prm->sched_deadline) != 0 &&
> +	       (s64)(&prm->sched_deadline - &prm->sched_runtime) >= 0;

Patch 6 brought this to my attention. Looks like using the address of
the fields is wrong. I know patch 6 fixes this, but lets make it
correct in this patch first.

Thanks,

-- Steve


> +}
> +
> +/*
>   * check the target process has a UID that matches the current process's
>   */
>  static bool check_same_owner(struct task_struct *p)
