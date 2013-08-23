Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3HWIBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:01:03 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:21445 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3HWIBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:01:00 -0400
Message-ID: <52171501.8050401@huawei.com>
Date: Fri, 23 Aug 2013 15:53:37 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 11/11] cpuset: export effective masks to userspace
References: <52148F52.0@huawei.com> <52148FFC.4080701@huawei.com> <20130821142001.GK19286@mtj.dyndns.org>
In-Reply-To: <20130821142001.GK19286@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/21 22:20, Tejun Heo wrote:
> On Wed, Aug 21, 2013 at 06:01:32PM +0800, Li Zefan wrote:
>>  	{
>> +		.name = "effective_cpus",
>> +		.flags = CFTYPE_SANE,
>> +		.read = cpuset_common_file_read,
>> +		.max_write_len = (100U + 6 * NR_CPUS),
>> +		.private = FILE_EFFECTIVE_CPULIST,
> 
> I don't think we need CFTYPE_SANE.  We can just expose these
> unconditionally, right?  It still means the same thing when !sane.
> 

It seems confusing if there're two interaces but they actually mean
the same thing.

Another reason I didn't do this is, they're not always the same. When
!sane, If cpus_allowed is empty, effective_cpus is not empty, and you
are not able to put tasks into this cpuset. So if we want to  expose
it unconditionally, I'll make sure cpus_allowed == effective_cpus
always stand when !sane.

