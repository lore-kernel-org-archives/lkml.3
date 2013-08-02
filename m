Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab3HBKQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:16:03 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:52518 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3HBKP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:15:59 -0400
Message-ID: <51FB85F5.6060600@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 15:42:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Update][PATCH] cpufreq: Do not hold driver module references
 for additional policy CPUs
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <51FAC46D.1000703@linux.vnet.ibm.com>	<1757496.qSuJuAun9Z@vostro.rjw.lan> <2298639.F0Qv2QqRnZ@vostro.rjw.lan> <CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com> <51FB568B.1040902@linux.vnet.ibm.com> <CAKohpomGi0FzL-3FwsP=zzmbNMNUc6CN0S9Lyba+vx8m7MS4uQ@mail.gmail.com>
In-Reply-To: <CAKohpomGi0FzL-3FwsP=zzmbNMNUc6CN0S9Lyba+vx8m7MS4uQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080210-5816-0000-0000-0000093B896D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 03:06 PM, Viresh Kumar wrote:
> On 2 August 2013 12:19, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> On 08/02/2013 10:07 AM, Viresh Kumar wrote:
>>> So, we can't rmmod the module as soon as it is inserted and so the
>>> problem stays as is. :(
>>>
>>
>> No, we get one step closer to the solution, since we fix the inconsistency
>> between refcounts. Next step would be to get rid of refcounts and use
>> locking like you suggested. Then we can rmmod it easily. I'm assuming
>> Rafael has the same plan.
> 
> Not really. We are putting the reference at the end of add_dev() and
> so refcount would be zero when we aren't running any critical sections.
> And so, we can rmmod the module now and that problem is gone.
> 

Ah, yes, you are right.

> @Rafael: I will try to do generic cleanups in cpufreq in coming time
> and will take care to remove .owner field completely in that. Until that
> point your patches look fine:
> 
> For both of your patches:
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
 
Regards,
Srivatsa S. Bhat

