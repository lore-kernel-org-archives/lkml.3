Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3KZNBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:01:54 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:35537 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3KZNBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:01:49 -0500
Message-ID: <52949BC1.8090001@linaro.org>
Date: Tue, 26 Nov 2013 14:01:53 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, mingo@redhat.com, peterz@infradead.org,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
CC: james.hogan@imgtec.com, jason.low2@hp.com, gregkh@linuxfoundation.org,
        hanjun.guo@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] sched: remove cpu_load decay.
References: <1385102235-25664-1-git-send-email-alex.shi@linaro.org> <528F4A78.1080505@linaro.org> <52918ECC.6080707@linaro.org> <529495AF.4020600@linaro.org> <52949972.6090101@linaro.org>
In-Reply-To: <52949972.6090101@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 01:52 PM, Alex Shi wrote:
> On 11/26/2013 08:35 PM, Daniel Lezcano wrote:
>>
>>
>> Here the new results with your patchset + patch #5
>>
>> I have some issues with perf for the moment, so I will fix it up and
>> send the result after.
>
> Thanks a lot, Daniel!
> The result is pretty good!, thread/pipe performance has a slight little
> drop, but processes performance increase about 25%!
>
>
>>
>>
>> 527d1511310a          / + patchset + #5
>>
>> hackbench -T -s 4096 -l 1000 -g 10 -f 40
>> 26.677                  30.308
>> 27.914             28.497
>> 28.390             30.360
>> 28.048             28.587
>> 26.344             29.513
>> 27.848             28.706
>> 28.315             30.152
>> 28.232             29.721
>> 26.549             28.766
>> 30.340             38.801
>> hackbench -p -s 4096 -l 1000 -g 10 -f 40
>> 34.522                  35.469
>> 34.545             34.966
>> 34.469             35.342
>> 34.115             35.286
>> 34.457             35.592
>> 34.561             35.314
>> 34.459             35.316
>> 34.054             35.629
>> 34.532             35.149
>> 34.459             34.876
>> hackbench -P -s 4096 -l 1000 -g 10 -f 40
>> 38.938                  30.308
>> 39.363             28.497
>> 39.340             30.360
>> 38.909             28.587
>> 39.095             29.513
>> 38.869             28.706
>> 39.041             30.152
>> 38.939             29.721
>> 38.992             28.766
>> 38.947             38.801

Ok, bad copy-paste, the third test run results with the patchset is wrong.

hackbench -P -s 4096 -l 1000 -g 10 -f 40
38.938	     	     39.585	     	      	     	
39.363		     39.008
39.340		     38.954
38.909		     39.273
39.095		     38.755
38.869		     39.003
39.041		     38.945
38.939		     38.005
38.992		     38.994
38.947		     38.855



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

