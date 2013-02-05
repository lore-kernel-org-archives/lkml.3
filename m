Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3BEPBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:01:19 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:51529 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab3BEPBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:01:17 -0500
Message-ID: <51111E9A.4000504@gmail.com>
Date: Tue, 05 Feb 2013 23:00:42 +0800
From: Lai Jiangshan <eag0628@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/13] workqueue: don't set work cwq until we queued it
 on pool
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com> <1359657696-2767-4-git-send-email-laijs@cn.fujitsu.com> <20130204212808.GC27963@mtj.dyndns.org>
In-Reply-To: <20130204212808.GC27963@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/2/5 5:28, Tejun Heo 写道:
> Hello, again.
>
> On Fri, Feb 01, 2013 at 02:41:26AM +0800, Lai Jiangshan wrote:
>> @@ -110,6 +110,7 @@ struct delayed_work {
>>   	struct work_struct work;
>>   	struct timer_list timer;
>>   	int cpu;
>> +	struct workqueue_struct *wq;
>
> Can't we just replace delayed_work->cpu with delayed_work->cwq?  That
> way, we don't enlarge delayed_work while encoding both wq and cpu in
> delayed_work proper.
>
> Thanks.
>

The @cpu can be WORK_CPU_UNBOUND, and the current code will delay
to determine on which cpu should this work be queued until timeout,
I didn't want to change this behavior when I wrote the patch.

queue_delayed_work_on(WORK_CPU_UNBOUND, system_wq, dwork, delay);

But there is no "get_cwq(WORK_CPU_UNBOUND, system_wq)".
So we have to record the @wq to dwork, Or determine the cpu to queue
earlier which changes the current behavior. I'm OK with this change
if you want.

Thanks,
Lai

PS, again, @cpu and @wq can be saved/encoded in dwork.work.entry if needed.
