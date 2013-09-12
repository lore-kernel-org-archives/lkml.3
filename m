Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3ILHUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:20:21 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:50411 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3ILHUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:20:19 -0400
Message-ID: <52316A40.4050600@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 12:46:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
References: <cover.1378963070.git.viresh.kumar@linaro.org> <8f777cc6b41b2fed4bf71ce2adc36800353d5738.1378963070.git.viresh.kumar@linaro.org> <523161D1.9040005@linux.vnet.ibm.com> <CAKohpomz-EDbRNqv58zn6B+kC1jdjrxx68hoDrAj==+YbeTj=g@mail.gmail.com> <CAKohpomCXoO20cQyCrWtN0WgWnzvVmEqFxuwTU8V0GpXsQxgHw@mail.gmail.com>
In-Reply-To: <CAKohpomCXoO20cQyCrWtN0WgWnzvVmEqFxuwTU8V0GpXsQxgHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091207-8256-0000-0000-000009302410
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 12:26 PM, Viresh Kumar wrote:
> On 12 September 2013 12:17, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> Currently cpus never become zero as we clear mask only while there are
>> more than one cpu in a policy... Wait let me see what's the cleanest way
>> to get this fixed..
> 
> Okay, simply replace cpumask_first() with cpumask_any_but() in
> cpufreq_nominate_new_policy_cpu() :)
> 

That sounds good! Even the naming is much better, it conveys the intent
clearly.

Regards,
Srivatsa S. Bhat

