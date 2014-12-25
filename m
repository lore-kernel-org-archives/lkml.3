Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaLYUQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 15:16:26 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:49615 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaLYUQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 15:16:24 -0500
Date: Thu, 25 Dec 2014 15:16:20 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/5] workqueue: update wq_numa_possible_cpumask
Message-ID: <20141225201620.GC22951@htj.dyndns.org>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
 <1418379595-6281-3-git-send-email-laijs@cn.fujitsu.com>
 <20141212171821.GB20020@htj.dyndns.org>
 <548E411C.3030102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548E411C.3030102@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 10:02:04AM +0800, Lai Jiangshan wrote:
> 1) "NUMA code" = system's NUMA memory hotplug code, AKA, keep the numa mapping stable
> 
>    I think this is the better idea.  This idea came to my mind immediately at the time
>    I received the bug report.  And after some discussions, I was told that it is too HARD
>    to keep the numa mapping stable across multiple physical system-board/node online/offline.

If the arch needs to change it, that's fine, I guess.  What I'm saying
is that we should move this table building and maintenance to numa
code proper.  It was already a bit icky to build it inside workqueue.
Trying to manage it dynamically manage it from there is too ugly.
Let's please make this mapping table a proper part of NUMA
infrastructure with proper notification callbacks.

Thanks.

-- 
tejun
