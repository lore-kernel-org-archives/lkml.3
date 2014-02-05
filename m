Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaBEEE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 23:04:29 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37210 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaBEEE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 23:04:27 -0500
Message-ID: <52F1B773.6050901@linux.vnet.ibm.com>
Date: Wed, 05 Feb 2014 09:30:51 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: linux-pm@vger.kernel.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        len.brown@intel.com, benh@kernel.crashing.org,
        daniel.lezcano@linaro.org, srivatsa.bhat@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V3] cpuidle/governors: Fix logic in selection of idle
 states
References: <20140204083531.24802.63370.stgit@preeti.in.ibm.com> <52F0FE9F.501@linux.intel.com>
In-Reply-To: <52F0FE9F.501@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020504-8256-0000-0000-00000B4EF6CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On 02/04/2014 08:22 PM, Arjan van de Ven wrote:
> On 2/4/2014 12:35 AM, Preeti U Murthy wrote:
>> The cpuidle governors today are not handling scenarios where no idle
>> state
>> can be chosen. Such scenarios coud arise if the user has disabled all the
>> idle states at runtime or the latency requirement from the cpus is
>> very strict.
>>
>> The menu governor returns 0th index of the idle state table when no other
>> idle state is suitable. This is even when the idle state corresponding
>> to this
>> index is disabled or the latency requirement is strict and the
>> exit_latency
>> of the lowest idle state is also not acceptable. Hence this patch
>> fixes this logic in the menu governor by defaulting to an idle state
>> index
>>  of -1 unless any other state is suitable.
> 
> state 0 is defined as polling, and polling ALWAYS should be ok

Hmm.. you are right. This is convincing. There is no need for this patch.

Thanks

Regards
Preeti U Murthy
> 

