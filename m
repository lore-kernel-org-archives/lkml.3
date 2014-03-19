Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbaCSNft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:35:49 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:38632 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933817AbaCSNfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:35:46 -0400
MIME-Version: 1.0
In-Reply-To: <53298A7D.3080400@linux.vnet.ibm.com>
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org>
	<532840FD.308@linux.vnet.ibm.com>
	<CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com>
	<53296870.5010505@linux.vnet.ibm.com>
	<CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com>
	<53298A7D.3080400@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 19:05:45 +0530
Message-ID: <CAKohpomQjvkAaty-nBSb=Qyxvk0RhvkwNXC9194gmYr6Vpw5WA@mail.gmail.com>
Subject: Re: [RFC v3] cpufreq: Make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Daniel <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 17:45, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> +       bool                    transition_ongoing; /* Tracks transition status */
> +       struct mutex            transition_lock;
> +       wait_queue_head_t       transition_wait;

Similar to what I have done in my last version, why do you need
transition_ongoing and transition_wait? Simply work with
transition_lock? i.e. Acquire it for the complete transition sequence.
