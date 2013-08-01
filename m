Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3HATFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:05:10 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:33316 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3HATFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:05:07 -0400
Message-ID: <51FAB083.5050900@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 00:31:23 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH] cpufreq: Do not hold driver module references for
 additional policy CPUs
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <1864010.r8gSosnm8c@vostro.rjw.lan> <51FAA3B9.7040009@linux.vnet.ibm.com> <1656801.jLHjvytfNU@vostro.rjw.lan>
In-Reply-To: <1656801.jLHjvytfNU@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080118-9574-0000-0000-000008FE3A26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 12:31 AM, Rafael J. Wysocki wrote:
> On Thursday, August 01, 2013 11:36:49 PM Srivatsa S. Bhat wrote:
>> Its the cpufreq_cpu_get() hidden away in cpufreq_add_dev_symlink(). With
>> that taken care of, everything should be OK. Then we can change the
>> synchronization part to avoid using refcounts.
> 
> So I actually don't see why cpufreq_add_dev_symlink() needs to call
> cpufreq_cpu_get() at all, since the policy refcount is already 1 at the
> point it is called and the bumping up of the driver module refcount is
> pointless.
> 

Hmm, yes, it seems so.

> However, if I change that I also need to change the piece of code that
> calls the complementary cpufreq_cpu_put() and I kind of cannot find it.
> 

... I guess that's because you are looking at the code with your patch
applied (and your patch removed that _put()) ;-)

Its this part in __cpufreq_remove_dev():

1303         } else {
1304 
1305                 if (!frozen) {
1306                         pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
1307                         cpufreq_cpu_put(data);
1308                 }
1309 

 
Regards,
Srivatsa S. Bhat

