Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3HFCWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 22:22:07 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:4613 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3HFCV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 22:21:56 -0400
Message-ID: <52005D92.1090103@huawei.com>
Date: Tue, 6 Aug 2013 10:21:06 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] cgroup, memcg: move cgroup_event implementation
 to memcg
References: <1375632446-2581-1-git-send-email-tj@kernel.org> <1375632446-2581-4-git-send-email-tj@kernel.org> <20130805170928.GB23751@mtj.dyndns.org> <5200593C.7090005@huawei.com>
In-Reply-To: <5200593C.7090005@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/6 10:02, Li Zefan wrote:
>>  static struct cftype mem_cgroup_files[] = {
>>  	{
>>  		.name = "usage_in_bytes",
>> @@ -5973,6 +6192,12 @@ static struct cftype mem_cgroup_files[] = {
>>  		.read_u64 = mem_cgroup_hierarchy_read,
>>  	},
>>  	{
>> +		.name = "cgroup.event_control",
>> +		.write_string = cgroup_write_event_control,
>> +		.flags = CFTYPE_NO_PREFIX,
>> +		.mode = S_IWUGO,
>> +	},
> 
> One of the misdesign of cgroup eventfd is, cgroup.event_control is
> totally redunant...
> 

ok. write_string() is needed to accept arguments and pass them to
the event register function. still not good.

