Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab3HBJgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:36:47 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:51899 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584Ab3HBJgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:36:44 -0400
MIME-Version: 1.0
In-Reply-To: <51FB568B.1040902@linux.vnet.ibm.com>
References: <2362640.pUofnXyzOi@vostro.rjw.lan>
	<51FAC46D.1000703@linux.vnet.ibm.com>
	<1757496.qSuJuAun9Z@vostro.rjw.lan>
	<2298639.F0Qv2QqRnZ@vostro.rjw.lan>
	<CAKohponru8Z1fod43dVtAODmYuMTGX70+73b8wk4wuGN=Vuh-w@mail.gmail.com>
	<51FB568B.1040902@linux.vnet.ibm.com>
Date: Fri, 2 Aug 2013 15:06:41 +0530
Message-ID: <CAKohpomGi0FzL-3FwsP=zzmbNMNUc6CN0S9Lyba+vx8m7MS4uQ@mail.gmail.com>
Subject: Re: [Update][PATCH] cpufreq: Do not hold driver module references for
 additional policy CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 August 2013 12:19, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 08/02/2013 10:07 AM, Viresh Kumar wrote:
>> So, we can't rmmod the module as soon as it is inserted and so the
>> problem stays as is. :(
>>
>
> No, we get one step closer to the solution, since we fix the inconsistency
> between refcounts. Next step would be to get rid of refcounts and use
> locking like you suggested. Then we can rmmod it easily. I'm assuming
> Rafael has the same plan.

Not really. We are putting the reference at the end of add_dev() and
so refcount would be zero when we aren't running any critical sections.
And so, we can rmmod the module now and that problem is gone.

@Rafael: I will try to do generic cleanups in cpufreq in coming time
and will take care to remove .owner field completely in that. Until that
point your patches look fine:

For both of your patches:
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
