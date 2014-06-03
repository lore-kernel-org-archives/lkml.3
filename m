Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbaFCISt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:18:49 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:47737 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaFCISq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
References: <20140526205337.1100.55275.stgit@srivatsabhat.in.ibm.com>
Date: Tue, 3 Jun 2014 13:48:46 +0530
Message-ID: <CAKohpokdnHag=79cXuwgNjX-k+JJU9GE3KUBhixcj3PZ6y78GQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: governor: Be friendly towards latency-sensitive
 bursty workloads
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 May 2014 02:23, Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:

Looks fine, some nits..

> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> -void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
> +void dbs_check_cpu(struct dbs_data *dbs_data, int cpu,
> +                  unsigned int sampling_rate)

We don't need to pass a new argument, we can get all the information from
dbs_data alone. Its already done for multiple routines. Let me know if you
find it difficult to figure out..
