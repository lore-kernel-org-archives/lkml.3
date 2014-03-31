Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaCaEZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 00:25:42 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:39567 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaCaEZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 00:25:40 -0400
MIME-Version: 1.0
In-Reply-To: <1396037484-23907-1-git-send-email-ego@linux.vnet.ibm.com>
References: <1396037484-23907-1-git-send-email-ego@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2014 09:55:40 +0530
Message-ID: <CAKohpo=jvswNPmUPEbS79bSp9ZWC1e3DjaEUX=O4CWMXfufHrw@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] powernv,cpufreq: Dynamic Frequency Scaling support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 March 2014 01:41, Gautham R. Shenoy <ego@linux.vnet.ibm.com> wrote:
> From: "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>
>
> Hi,
>
> This is v5 of the patchset to enable dynamic frequency scaling on IBM
> PowerNV platforms. This patchset does address all the review comments
> obtained for v4 (which can be found at [1]).
>
> Changes from v4:
>
>     * Created a separate patch to select the CPUFreq related Config
>       options for PowerNV
>
>     * Dropped the per-core locking hunks in
>       drivers/cpufreq/powernv-cpufreq.c since the CPUFreq core takes
>       care of the for us after the following commit which is present in
>       linux-next:
>
>         commit 12478cf0c55e5969f740bb38a24b1a0104ae18d8
>         Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>         Date:   Mon Mar 24 13:35:44 2014 +0530
>
>         cpufreq: Make sure frequency transitions are serialized
>
>     * [PATCH v5 3/3] gets rid of the powernv_pstate_ids[] array that
>       was being used to record the pstate ids. After the following
>       patch it is safe to use cpufreq_frequency_table.driver_data
>       since it is opaque to the cpufreq core:
>
>         From: Viresh Kumar <viresh.kumar@linaro.org>
>         Date: 2014-03-28 13:53:47
>         url: http://marc.info/?l=linux-pm&m=139601416804702&w=2
>
>         cpufreq: create another field .flags in cpufreq_frequency_table
>
> The patchset is based on the commit
> 201544be8c37dffbf069bb5fc9edb5674f8c1754 of the linux-next tree.
>
> While all the patches in the patchset apply cleanly on linux-next,
> [PATCH v5 3/3] requires the Viresh's patch that was mentioned
> above. Otherwise, the frequency corresponding to pstate id -3 will be
> omited while reporting the "scaling_available_frequencies" in sysfs.
>
> [1]: http://marc.info/?l=linux-pm&m=139585297620612&w=2
>
> Gautham R. Shenoy (2):
>   powernv, cpufreq: Select CPUFreq related Kconfig options for powernv

Make this patch 3/3 (Probably Rafael can do this while applying)

>   powernv,cpufreq: Use cpufreq_frequency_table.driver_data to store
>     pstate ids
>
> Vaidyanathan Srinivasan (1):
>   powernv, cpufreq: cpufreq driver for powernv platform

Otherwise,

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
