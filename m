Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaAPCCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:02:13 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56186 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaAPCCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:02:10 -0500
Message-ID: <52D73D9E.8090402@linaro.org>
Date: Thu, 16 Jan 2014 10:02:06 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        lkp@linux.intel.com
Subject: Re: [sched] 73628fba4: +69% context switches
References: <20140111101956.GA11150@localhost> <52D3804A.8060700@linaro.org> <20140116012301.GA2535@localhost>
In-Reply-To: <20140116012301.GA2535@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 09:23 AM, Fengguang Wu wrote:
> On Mon, Jan 13, 2014 at 01:57:30PM +0800, Alex Shi wrote:
>> On 01/11/2014 06:19 PM, Fengguang Wu wrote:
>>> Alex,
>>>
>>> FYI, we find much increased interrupts and context switches introduced
>>> by commit 73628fba4 ("sched: unify imbalance bias for target group")
>>> in your noload branch:
>>
>> Many thanks for the generous and quick testing! :)
>>
>> few questions for the results and give a testing patch for try. it also push on github. 
>>
>> What's about the aim7 shell_rtns_1 and shared throughput?
> 
> The throughputs remain the same.  We only report changed numbers.

So many interrupt increase doesn't cause any performance change, that
make more doubt of data correction.
Could you like to give the typical vmstat output? Specially the
sys/us/wa/id time percentages.

BTW
Just confirm, the benchmark is running on a native machine, not a kvm
guest, right?

>>
>> commit c5a8778a132cfa882609fbccb4ee6542eac9866d
>> Author: Alex Shi <alex.shi@linaro.org>
>> Date:   Mon Jan 13 13:54:30 2014 +0800
>>
>>     more bias towards local cpu group
> 
> 
> In your rebased tree, there are still much increased interrupts and
> context switches:
> 

Thanks for your great testing!
Seems I tune it to the wrong direction. :)

Will change to another directory to reduce the questionable interrupt/CS
increase.

-- 
Thanks
    Alex
