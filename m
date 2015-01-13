Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbbAMPW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:22:29 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:39423 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbbAMPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:22:27 -0500
Date: Tue, 13 Jan 2015 10:22:24 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?IklzaGltYXRzdSwgWWFzdWFraS/nn7Pmnb4g6Z2W56ugIg==?= 
	<isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] workqueue: update numa affinity info at node hotplug
Message-ID: <20150113152224.GA2976@htj.dyndns.org>
References: <54905F87.2030302@jp.fujitsu.com>
 <549061BD.3040802@jp.fujitsu.com>
 <5490DE23.9000602@cn.fujitsu.com>
 <5490F70E.4010703@jp.fujitsu.com>
 <54910CFD.4070203@jp.fujitsu.com>
 <20141225201156.GA22951@htj.dyndns.org>
 <54B4C6ED.9060501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B4C6ED.9060501@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 13, 2015 at 03:19:09PM +0800, Lai Jiangshan wrote:
> The Mapping of the *online* cpus to nodes is already maintained by numa code.
> 
> What the workqueue needs is a special Mapping:
> 	The Mapping of the *possible* cpus to nodes
> 
> But this mapping (if the numa code maintain it) is a trouble:
> 	"possible" implies the mapping is stable/constant/immutable, it is hard to
> 	ensure it in the numa code.
> 
> if mutability of this mapping is acceptable, we just move 20~40 LOC
> of code from workqueue to numa code, all the other complexities
> about it are still in workqueue.c.

Make numa code maintain the mapping to the best of its knowledge and
invoke notification callbacks when it changes.  Even if that involves
slightly more code, that's the right thing to do at this point.  This
puts the logic which is complicated by the fact that the mapping may
change where it's caused not some random unrelated place.  It'd be
awesome if somebody more familiar with the numa side can chime in and
explain why this mapping change can't be avoided.

Thanks.

-- 
tejun
