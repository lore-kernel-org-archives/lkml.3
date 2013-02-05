Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab3BEPGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:06:33 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41017 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab3BEPGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:06:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130204212808.GC27963@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
	<1359657696-2767-4-git-send-email-laijs@cn.fujitsu.com>
	<20130204212808.GC27963@mtj.dyndns.org>
Date: Tue, 5 Feb 2013 23:06:29 +0800
Message-ID: <CACvQF50HsspuHAomRXRFBG-PL=2XkAs3j2cpkhND7OhpaBVs4w@mail.gmail.com>
Subject: Re: [PATCH 03/13] workqueue: don't set work cwq until we queued it on pool
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
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
I didn't want to change this behavior when I.

queue_delayed_work_on(WORK_CPU_UNBOUND, system_wq, dwork, delay);

But there is no "get_cwq(WORK_CPU_UNBOUND, system_wq)".
So we have to record the @wq to dwork, Or determine the cpu to queue
earlier which changes the current behavior. I'm OK with this change.

Thanks,
Lai

PS, again, @cpu and @wq can be saved in dwork.work.entry if needed.
