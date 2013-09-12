Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3ILG47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:56:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40245 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3ILG44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:56:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomz-EDbRNqv58zn6B+kC1jdjrxx68hoDrAj==+YbeTj=g@mail.gmail.com>
References: <cover.1378963070.git.viresh.kumar@linaro.org>
	<8f777cc6b41b2fed4bf71ce2adc36800353d5738.1378963070.git.viresh.kumar@linaro.org>
	<523161D1.9040005@linux.vnet.ibm.com>
	<CAKohpomz-EDbRNqv58zn6B+kC1jdjrxx68hoDrAj==+YbeTj=g@mail.gmail.com>
Date: Thu, 12 Sep 2013 12:26:56 +0530
Message-ID: <CAKohpomCXoO20cQyCrWtN0WgWnzvVmEqFxuwTU8V0GpXsQxgHw@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpufreq: use correct values of cpus in __cpufreq_remove_dev_finish()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Warren <swarren@wwwdotorg.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 September 2013 12:17, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Currently cpus never become zero as we clear mask only while there are
> more than one cpu in a policy... Wait let me see what's the cleanest way
> to get this fixed..

Okay, simply replace cpumask_first() with cpumask_any_but() in
cpufreq_nominate_new_policy_cpu() :)
