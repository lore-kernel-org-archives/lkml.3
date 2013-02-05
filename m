Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3BEMEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:04:14 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:48167 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3BEMEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:04:11 -0500
Message-ID: <5110F52F.5010901@gmail.com>
Date: Tue, 05 Feb 2013 20:03:59 +0800
From: Lai Jiangshan <eag0628@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] workqueue: remove WORK_CPU_NONE
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com> <1359657696-2767-2-git-send-email-laijs@cn.fujitsu.com> <20130204194942.GZ27963@mtj.dyndns.org>
In-Reply-To: <20130204194942.GZ27963@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/2/5 3:49, Tejun Heo 写道:
> Hello, Lai.
>
> On Fri, Feb 01, 2013 at 02:41:24AM +0800, Lai Jiangshan wrote:
>> In __next_wq_cpu() for_each_*wq_cpu(), the name WORK_CPU_LAST
>> is proper than WORK_CPU_NONE, convert them to WORK_CPU_LAST.
>>
>> WORK_CPU_NONE is not used any more, just remove it.
> ...
>>   #define for_each_wq_cpu(cpu)						\
>>   	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, 3);		\
>> -	     (cpu) < WORK_CPU_NONE;					\
>> +	     (cpu) < WORK_CPU_LAST;					\
>>   	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, 3))
>
> LAST implies that it's the last element of the range and thus that
> it's an inclusive range.  Maybe we should rename it to WORK_CPU_END?
>

You are right, WORK_CPU_END seems better.

