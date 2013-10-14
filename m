Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3JNPO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:14:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:42927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab3JNPO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:14:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,493,1378882800"; 
   d="scan'208";a="410667995"
Message-ID: <525C0A51.2080407@linux.intel.com>
Date: Mon, 14 Oct 2013 08:14:25 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        pjt@google.com, rjw@sisk.pl, dirk.j.brandewie@intel.com,
        vincent.guittot@linaro.org, alex.shi@linaro.org,
        preeti@linux.vnet.ibm.com, efault@gmx.de, corbet@lwn.net,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 4/7] sched: power: Remove power capacity hints for
 kworker threads
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com> <1381511957-29776-5-git-send-email-morten.rasmussen@arm.com> <20131014133356.GN3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014133356.GN3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 6:33 AM, Peter Zijlstra wrote:
> On Fri, Oct 11, 2013 at 06:19:14PM +0100, Morten Rasmussen wrote:
>> Removing power hints for kworker threads enables easier use of
>> workqueues in the power driver late callback. That would otherwise
>> lead to an endless loop unless it is prevented in the power driver.
>
> There's many kworker users; some of them actually consume lots of
> cputime. Therefore how did you come to the conclusion that excepting all
> users was the better choice of a little added complexity in the one
> place where it actually matters?

.. and likely only for a very few architectures

x86, and I suspect modern ARM, can change frequency synchronously.
(using an instruction or maybe two or three for ARM)

