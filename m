Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbbAMHSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:18:04 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:50902 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751067AbbAMHSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:18:02 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="55969917"
Message-ID: <54B4C6ED.9060501@cn.fujitsu.com>
Date: Tue, 13 Jan 2015 15:19:09 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?IklzaGltYXRzdSwgWWFzdWFraS/nn7Pmnb4g6Z2W56ugIg==?= 
	<isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] workqueue: update numa affinity info at node hotplug
References: <54905F87.2030302@jp.fujitsu.com> <549061BD.3040802@jp.fujitsu.com> <5490DE23.9000602@cn.fujitsu.com> <5490F70E.4010703@jp.fujitsu.com> <54910CFD.4070203@jp.fujitsu.com> <20141225201156.GA22951@htj.dyndns.org>
In-Reply-To: <20141225201156.GA22951@htj.dyndns.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2014 04:11 AM, Tejun Heo wrote:
> On Wed, Dec 17, 2014 at 01:56:29PM +0900, Kamezawa Hiroyuki wrote:
>> Let me correct my words. Main purpose of this patch 1/2 is handling a case "node disappers" after boot.
>> And try to handle physicall node hotplug caes.
>>
>> Changes of cpu<->node relationship at CPU_ONLINE is handled in patch 2/2.
> 
> Can you please make numa code itself maintain the cpu to nodemask
> maps?  Let's make workqueue a simple consumer of that and we don't
> have proper notification mechanism for node up/down events?
> 
> Thanks.
> 

The Mapping of the *online* cpus to nodes is already maintained by numa code.

What the workqueue needs is a special Mapping:
	The Mapping of the *possible* cpus to nodes

But this mapping (if the numa code maintain it) is a trouble:
	"possible" implies the mapping is stable/constant/immutable, it is hard to
	ensure it in the numa code.

if mutability of this mapping is acceptable, we just move 20~40 LOC of code
from workqueue to numa code, all the other complexities about it are still in workqueue.c.

Thanks
Lai
