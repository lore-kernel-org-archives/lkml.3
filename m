Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180Ab3IDHLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 03:11:04 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:43853 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab3IDHLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 03:11:02 -0400
X-AuditID: 9c93017e-b7c76ae000003897-76-5226dd045cf1
From: Namhyung Kim <namhyung@kernel.org>
To: "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 10/13] tracing/uprobes: Fetch args before reserving a ring buffer
References: <1378187054-27401-1-git-send-email-namhyung@kernel.org>
	<1378187054-27401-11-git-send-email-namhyung@kernel.org>
	<5225C38C.2090305@huawei.com>
Date: Wed, 04 Sep 2013 16:10:59 +0900
In-Reply-To: <5225C38C.2090305@huawei.com> (zhangwei's message of "Tue, 3 Sep
	2013 19:10:04 +0800")
Message-ID: <87wqmxrri4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jovi,

[SNIP]

On Tue, 3 Sep 2013 19:10:04 +0800, zhangwei wrote:
>> +	if (atomic_inc_return(&uprobe_buffer_ref) == 1) {
>> +		int cpu;
>> +
>> +		uprobe_cpu_buffer = __alloc_percpu(PAGE_SIZE, PAGE_SIZE);
>> +		if (uprobe_cpu_buffer == NULL)
>> +			return -ENOMEM;
>> +
>
> Do we need add atomic_dec if allocate percpu buffer failed?

Good catch!  I'll fix it. :)

Thanks,
Namhyung


>
>> +		for_each_possible_cpu(cpu)
>> +			mutex_init(&per_cpu(uprobe_cpu_mutex, cpu));
>> +	}
>> +
>>  	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
