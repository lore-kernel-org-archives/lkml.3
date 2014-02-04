Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaBDOw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 09:52:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:12593 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbaBDOw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 09:52:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,780,1384329600"; 
   d="scan'208";a="338703304"
Message-ID: <52F0FE9F.501@linux.intel.com>
Date: Tue, 04 Feb 2014 06:52:15 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>, linux-pm@vger.kernel.org,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org, len.brown@intel.com
CC: benh@kernel.crashing.org, daniel.lezcano@linaro.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V3] cpuidle/governors: Fix logic in selection of idle
 states
References: <20140204083531.24802.63370.stgit@preeti.in.ibm.com>
In-Reply-To: <20140204083531.24802.63370.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/2014 12:35 AM, Preeti U Murthy wrote:
> The cpuidle governors today are not handling scenarios where no idle state
> can be chosen. Such scenarios coud arise if the user has disabled all the
> idle states at runtime or the latency requirement from the cpus is very strict.
>
> The menu governor returns 0th index of the idle state table when no other
> idle state is suitable. This is even when the idle state corresponding to this
> index is disabled or the latency requirement is strict and the exit_latency
> of the lowest idle state is also not acceptable. Hence this patch
> fixes this logic in the menu governor by defaulting to an idle state index
>  of -1 unless any other state is suitable.

state 0 is defined as polling, and polling ALWAYS should be ok

