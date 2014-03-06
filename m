Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaCFVPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:15:14 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:40831 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaCFVPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:15:11 -0500
Date: Thu, 6 Mar 2014 16:15:06 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch 10/11] mm, memcg: add memory.oom_control notification for
 system oom
Message-ID: <20140306211506.GD17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1403041957140.8067@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403041957140.8067@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 07:59:41PM -0800, David Rientjes wrote:
> Now that process handling system oom conditions have access to a small
> amount of memory reserves, we need a way to notify those process on
> system oom conditions.
> 
> When a userspace process waits on the root memcg's memory.oom_control, it
> will wake up anytime there is a system oom condition.
> 
> This is a special case of oom notifiers since it doesn't subsequently
> notify all memcgs under the root memcg (all memcgs on the system).  We
> don't want to trigger those oom handlers which are set aside specifically
> for true memcg oom notifications that disable their own oom killers to
> enforce their own oom policy, for example.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Until consensus on the whole approach can be reached,

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
