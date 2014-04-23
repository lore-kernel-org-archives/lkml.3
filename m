Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaDWBdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:33:42 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:45610 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753461AbaDWBdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:33:39 -0400
X-IronPort-AV: E=Sophos;i="4.97,907,1389715200"; 
   d="scan'208";a="29600427"
Message-ID: <53571958.7050606@cn.fujitsu.com>
Date: Wed, 23 Apr 2014 09:37:28 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 V3] workqueue: substitute POOL_FREEZING with __WQ_FREEZING
References: <1398081561-12618-1-git-send-email-laijs@cn.fujitsu.com> <20140421222035.GA22730@htj.dyndns.org> <5355CA43.5040608@cn.fujitsu.com> <20140422204623.GC3615@mtj.dyndns.org>
In-Reply-To: <20140422204623.GC3615@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 04:46 AM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 22, 2014 at 09:47:47AM +0800, Lai Jiangshan wrote:
>> Testing workqueue_freezing requires wq_pool_mutex held.
>> Although almost-all pwq_adjust_max_active() are called with wq_pool_mutex held,
>> except workqueue_set_max_active(). But I hope pwq_adjust_max_active()
>> don't require the heavy wq_pool_mutex.
> 
> No it doesn't require wq_pool_mutex to be held.  All it requires is
> that the changed state is visible on the subsequent
> pwq_adjust_max_active() invocatino which is already trivially
> guaranteed.
> 

Good! I understood! Could you respin the patch? I'm afraid
I can't explain it well in the comments.

For me, I always prefer locks for non-performance critical path,
locks help review, I believe your comment will do so.

Thanks,
Lai
