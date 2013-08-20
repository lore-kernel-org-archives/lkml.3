Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3HTGfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:35:41 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:62507 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3HTGfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:35:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponkLac2GzZ5-PRoTzdx8EhuCWT-eafRtYhkJ6cN_WrXSA@mail.gmail.com>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
	<e54ce908bb964d643a2bbb945ed4a8dcb3ea00bf.1375809311.git.viresh.kumar@linaro.org>
	<1582060.zfvsylJcxu@vostro.rjw.lan>
	<CAKohponkLac2GzZ5-PRoTzdx8EhuCWT-eafRtYhkJ6cN_WrXSA@mail.gmail.com>
Date: Tue, 20 Aug 2013 12:05:39 +0530
Message-ID: <CAKohpo=Y4FLw+F34zfpaDUOmrgnFRRADhrctLzLw+GEcj4CheA@mail.gmail.com>
Subject: Re: [PATCH V2 07/11] cpufreq: Use cpufreq_policy_list for iterating
 over policies
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 August 2013 16:57, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> It wasn't my patch actually.. It only made it visible that's it :)
> The problem is:
> - On suspend all CPUs are removed and so governors are
> stopped.
> - On resume, handle_update() is called for the boot cpu and
> cpu_add_dev for all others.
>
> handle_update() doesn't start governor but only plays with
> CPUFREQ_GOV_LIMITS.. when we start adding other
> CPUs and call: cpufreq_add_policy_cpu() which fails in
> following call:
>
> __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
>
> and so cpufreq_policy_cpu never gets initialized to
> policy->cpu and stays at -1, and hence the crash.
>
> So, there are few problems with core at this point:
> - I don't understand how does the work done in
> cpufreq_add_dev() gets done for boot cpu during
> resume ? And so how does Srivatsa's "frozen" solution
> really works (I haven't had time to investigate, its not
> that I couldn't understand it :) )..
>
> - We need to start governor boot cpu in handle_update()
> and things would be solved...

Whatever I wrote here was simply _Bullshit_ :(

I am about to send you a fixup patchset that fixes this issue, and
yes it was my patch which introduced this problem :(, but
because of some mishandling of cpufreq_policy_list :)

--
viresh
