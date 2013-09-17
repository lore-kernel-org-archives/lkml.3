Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3IQPar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:30:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51717 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3IQPap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:30:45 -0400
Message-ID: <52387343.7040007@wwwdotorg.org>
Date: Tue, 17 Sep 2013 09:20:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, srivatsa.bhat@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
References: <cover.1378963070.git.viresh.kumar@linaro.org> <8f777cc6b41b2fed4bf71ce2adc36800353d5738.1378963070.git.viresh.kumar@linaro.org>
In-Reply-To: <8f777cc6b41b2fed4bf71ce2adc36800353d5738.1378963070.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 11:25 PM, Viresh Kumar wrote:
> This broke after a recent change "cedb70a cpufreq: Split __cpufreq_remove_dev()
> into two parts" from Srivatsa..
> 
> Consider a scenario where we have two CPUs in a policy (0 & 1) and we are
> removing cpu 1. On the call to __cpufreq_remove_dev_prepare() we have cleared 1
> from policy->cpus and now on a call to __cpufreq_remove_dev_finish() we read
> cpumask_weight of policy->cpus, which will come as 1 and this code will behave
> as if we are removing the last cpu from policy :)
> 
> Fix it by clearing cpu mask in __cpufreq_remove_dev_finish() instead of
> __cpufreq_remove_dev_prepare().

I see this patch isn't in linux-next yet, nor did it make 3.12-rc1. I
assume it'll make 3.12-rc2? It solves various CPU hotplug and
suspend/resume issues for me.
