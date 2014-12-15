Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaLOBYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 20:24:47 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:52798 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbaLOBYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 20:24:37 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="45140300"
Message-ID: <548E3948.7040105@cn.fujitsu.com>
Date: Mon, 15 Dec 2014 09:28:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/5] workqueue: update NUMA affinity for the node lost
 CPU
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <1418379595-6281-5-git-send-email-laijs@cn.fujitsu.com> <20141212172739.GD20020@htj.dyndns.org>
In-Reply-To: <20141212172739.GD20020@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014 01:27 AM, Tejun Heo wrote:
> On Fri, Dec 12, 2014 at 06:19:54PM +0800, Lai Jiangshan wrote:
>> We fixed the major cases when the numa mapping is changed.
>>
>> We still have the assumption that when the node<->cpu mapping is changed
>> the original node is offline, and the current code of memory-hutplug also
>> prove this.
>>
>> This assumption might be changed in future and the orig_node is still online
>> in some cases.  And in these cases, the cpumask of the pwqs of the orig_node
>> still contains the onlining CPU which is a CPU of another node, and the worker
>> may run on the onlining CPU (aka run on the wrong node).
>>
>> So we drop this assumption and make the code calls wq_update_unbound_numa()
>> to update the affinity in this case.
> 
> This is seriously obfuscating.  I really don't think meddling with
> existing pools is a good idea.  

> The foundation those pools were standing are gone.

This statement is not true unless we write some code to force them,
dequeue them from the unbound_pool_hash, for example.

> Drain and discard the pools.  Please don't try to
> retro-fit it to new foundations.
> 
> Thanks.
> 

