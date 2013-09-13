Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3IMPzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:55:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54651 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3IMPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:55:07 -0400
Date: Fri, 13 Sep 2013 16:54:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 206/228] cpufreq: sa11x0: remove calls to
	cpufreq_notify_transition()
Message-ID: <20130913155424.GB12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org> <6e2ca86ce948c0bc35f7709baf22672771fcf1e8.1379063063.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e2ca86ce948c0bc35f7709baf22672771fcf1e8.1379063063.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 06:32:32PM +0530, Viresh Kumar wrote:
> Most of the drivers do following in their ->target_index() routines:
> 
> 	struct cpufreq_freqs freqs;
> 	freqs.old = old freq...
> 	freqs.new = new freq...
> 
> 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
> 
> 	/* Change rate here */
> 
> 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
> 
> This is replicated over all cpufreq drivers today and there doesn't exists a
> good enough reason why this shouldn't be moved to cpufreq core instead.
> 
> Earlier patches have added support in cpufreq core to do cpufreq notification on
> frequency change, this one removes it from this driver.
> 
> Some related minor cleanups are also done along with it.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Shouldn't this patch set CPUFREQ_ASYNC_NOTIFICATION somewhere?
