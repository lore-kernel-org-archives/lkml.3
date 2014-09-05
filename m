Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaIEHHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:07:42 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35799 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaIEHHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:07:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140905070134.2831.8175.stgit@preeti.in.ibm.com>
References: <20140905065952.2831.66731.stgit@preeti.in.ibm.com>
	<20140905070134.2831.8175.stgit@preeti.in.ibm.com>
Date: Fri, 5 Sep 2014 12:37:40 +0530
Message-ID: <CAKohpokThCn3ze7KZ0zZNN8zyVCxjdL=pGBhWcAvVr9T23RxSg@mail.gmail.com>
Subject: Re: [PATCH 2/2] powernv/cpufreq: Set the pstate of the last
 hotplugged out cpu in policy->cpus to minimum
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Shreyas Prabhu <shreyas@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2014 12:31, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:

> +       smp_call_function_any(policy->cpus, set_pstate, &freq_data, 1);

We will surely have a single CPU alive at this point, so should we call
this function on policy->cpu directly ?
