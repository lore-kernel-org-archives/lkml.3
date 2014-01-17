Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaAQDPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:15:47 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:33962 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaAQDPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:15:41 -0500
Message-ID: <52D8A054.5030203@linux.vnet.ibm.com>
Date: Fri, 17 Jan 2014 11:15:32 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, Mike Galbraith <efault@gmx.de>
CC: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sched: select_idle_sibling macro optimize
References: <1389795808-32013-1-git-send-email-alex.shi@linaro.org> <52D7DAF5.4020506@linaro.org> <1389880335.5418.46.camel@marge.simpson.net> <52D891FB.9020308@linaro.org>
In-Reply-To: <52D891FB.9020308@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011703-5490-0000-0000-000004CB5345
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 10:14 AM, Alex Shi wrote:
[snip]
>>
>> When is that gonna happen?
> 
> I had seen this in a Intel platform, you may have both CPU domain and MC
> domain layer, because the domain flag is different, then they can not be
> merged. and then the CPU domain just has one group.

CPU and MC are different domains, isn't it?

General should like:

CPU	cpu0				cpu1
MC	core0		core1		core0		core1
SMT	cpu 0	cpu 1	cpu 2	cpu 3	cpu 4	cpu 5	cpu 6	cpu 7

So for cpu0:

CPU	sg0:cpu0,1,2,3	sg1:cpu4,5,6,7
MC	sg0:cpu0,1	sg1:cpu2,3
SMT	sg0:cpu0	sg1:cpu1

If one domain only have one group, that's sounds really a weird topology...

Regards,
Michael Wang

>>
>> -Mike
>>
>>
> 
> 

