Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab3CZMhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:37:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44230 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758077Ab3CZMhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:37:37 -0400
Message-ID: <1364301443.5053.9.camel@laptop>
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Date: Tue, 26 Mar 2013 13:37:23 +0100
In-Reply-To: <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	 <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
> +static bool is_light_task(struct task_struct *p)
> +{
> +       /* A light task runs less than 20% in average */
> +       return ((p->se.avg.runnable_avg_sum  * 5) <
> +                       (p->se.avg.runnable_avg_period));
> +}

OK, so we have a 'problem' here, we initialize runnable_avg_* to 0, but
we want to 'assume' a fresh task is fully 'loaded'. IIRC Alex ran into
this as well.

PJT, do you have any sane solution for this, I forgot what the result
of the last discussion was -- was there any?

