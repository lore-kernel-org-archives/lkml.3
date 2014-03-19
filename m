Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaCSEtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 00:49:18 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36094 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbaCSEtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 00:49:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140318154412.GA769@localhost.localdomain>
References: <1e1b53537217d58d48c2d7a222a9c3ac47d5b64c.1395140107.git.viresh.kumar@linaro.org>
	<20140318154412.GA769@localhost.localdomain>
Date: Wed, 19 Mar 2014 10:19:16 +0530
Message-ID: <CAKohponTMm7DqEcM4Y-qsf9Gn9QjaEhfdeCELjPKB8wSbJK1DQ@mail.gmail.com>
Subject: Re: [PATCH] timer: remove code redundancy while calling get_nohz_timer_target()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2014 21:14, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Tue, Mar 18, 2014 at 04:26:07PM +0530, Viresh Kumar wrote:
>> +     if (pinned || !get_sysctl_timer_migration() || !idle_cpu(cpu))
>> +             return cpu;
>
> Maybe the pinned part should stay a caller detail. Although I don't really mind.

I tried that initially, but in that case the callers would have to call
smp_processor_id() in the else part and so decided to put that as well into this
routine only.

> The patch looks good!

Thanks.
