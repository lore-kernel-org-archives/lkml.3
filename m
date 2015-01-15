Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbbAOBWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:22:37 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:49073 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751145AbbAOBWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:22:36 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56082811"
Message-ID: <54B716A0.5020800@cn.fujitsu.com>
Date: Thu, 15 Jan 2015 09:23:44 +0800
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
References: <54905F87.2030302@jp.fujitsu.com> <549061BD.3040802@jp.fujitsu.com> <5490DE23.9000602@cn.fujitsu.com> <5490F70E.4010703@jp.fujitsu.com> <54910CFD.4070203@jp.fujitsu.com> <20141225201156.GA22951@htj.dyndns.org> <54B4C6ED.9060501@cn.fujitsu.com> <20150113152224.GA2976@htj.dyndns.org> <54B5D8B4.7010708@cn.fujitsu.com> <20150114135733.GB3565@htj.dyndns.org>
In-Reply-To: <20150114135733.GB3565@htj.dyndns.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 09:57 PM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Wed, Jan 14, 2015 at 10:47:16AM +0800, Lai Jiangshan wrote:
>>> Even if that involves slightly more code, that's the right thing to do at this point.
>>
>> Right, but in currently, the workqueue will be the only user, and I don't known
>> asking who to do it, so I may keep it in the workqueue.c.
> 
> The problem is that working around this in workqueue effectively hides
> what needs to be actively looked upon and decided.  It curently isn't
> currently defined even when such mappings can change or for which
> cpus?  Are all offline cpus up for grabs or just !present ones?  These
> are questions which can only be answered / determined from NUMA side
> and the sooner we deal with this properly the better.

So the solution_B totally keeps away from this spaghetti.

> 
>>> It'd be
>>> awesome if somebody more familiar with the numa side can chime in and
>>> explain why this mapping change can't be avoided.
>>
>> I'm also looking for someone answer it.
> 
> Exactly, whoever is requiring NUMA node remapping should explain and
> justify that and how the model to handle it can only be determined
> from that.
> 
> Thanks.
> 

