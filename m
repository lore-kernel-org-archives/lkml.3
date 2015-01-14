Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbbANCqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:46:11 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:44050 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751086AbbANCqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:46:10 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56023549"
Message-ID: <54B5D8B4.7010708@cn.fujitsu.com>
Date: Wed, 14 Jan 2015 10:47:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?IklzaGltYXRzdSwgWWFzdWFraS/nn7Pmnb4g6Z2W56ugIg==?= 
	<isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] workqueue: update numa affinity info at node hotplug
References: <54905F87.2030302@jp.fujitsu.com> <549061BD.3040802@jp.fujitsu.com> <5490DE23.9000602@cn.fujitsu.com> <5490F70E.4010703@jp.fujitsu.com> <54910CFD.4070203@jp.fujitsu.com> <20141225201156.GA22951@htj.dyndns.org> <54B4C6ED.9060501@cn.fujitsu.com> <20150113152224.GA2976@htj.dyndns.org>
In-Reply-To: <20150113152224.GA2976@htj.dyndns.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 11:22 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 13, 2015 at 03:19:09PM +0800, Lai Jiangshan wrote:
>> The Mapping of the *online* cpus to nodes is already maintained by numa code.
>>
>> What the workqueue needs is a special Mapping:
>> 	The Mapping of the *possible* cpus to nodes
>>
>> But this mapping (if the numa code maintain it) is a trouble:
>> 	"possible" implies the mapping is stable/constant/immutable, it is hard to
>> 	ensure it in the numa code.
>>
>> if mutability of this mapping is acceptable, we just move 20~40 LOC
>> of code from workqueue to numa code, all the other complexities
>> about it are still in workqueue.c.
> 
> Make numa code maintain the mapping to the best of its knowledge and
> invoke notification callbacks when it changes.  

The best of its knowledge is the physical onlined nodes and CPUs.
The cpu_present_mask can represent this knowledge. But it lacks of
the per-node cpu_present_mask and the notification callbacks.

> Even if that involves slightly more code, that's the right thing to do at this point.

Right, but in currently, the workqueue will be the only user, and I don't known
asking who to do it, so I may keep it in the workqueue.c.

> This puts the logic which is complicated by the fact that the mapping may
> change where it's caused not some random unrelated place.  


> It'd be
> awesome if somebody more familiar with the numa side can chime in and
> explain why this mapping change can't be avoided.

I'm also looking for someone answer it.

> 
> Thanks.
> 

