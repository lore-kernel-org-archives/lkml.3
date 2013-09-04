Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578Ab3IDI64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:58:56 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42566 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934449Ab3IDI6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:58:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130903224731.GC1412@cmpxchg.org>
References: <20130826133658.GA357@larmbr-lcx> <20130903224731.GC1412@cmpxchg.org>
From: Zhan Jianyu <nasa4836@gmail.com>
Date: Wed, 4 Sep 2013 16:58:12 +0800
Message-ID: <CAHz2CGXRz4ComkEZZBKknn-7g5fAtGCrKuJ+nrGNKZHsudYbYg@mail.gmail.com>
Subject: Re: [PATCH RESEND] mm/vmscan : use vmcan_swappiness( ) basing on
 MEMCG config to elimiate unnecessary runtime cost
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, mhocko@suse.cz, Balbir Singh <bsingharora@gmail.com>,
        kamezawa.hiroyu@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 6:47 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Mon, Aug 26, 2013 at 09:36:58PM +0800, larmbr wrote:
>> Currently, we get the vm_swappiness via vmscan_swappiness(), which
>> calls global_reclaim() to check if this is a global reclaim.
>>
>> Besides, the current implementation of global_reclaim() always returns
>> true for the !CONFIG_MEGCG case, and judges the other case by checking
>> whether scan_control->target_mem_cgroup is null or not.
>>
>> Thus, we could just use two versions of vmscan_swappiness() based on
>> MEMCG Kconfig , to eliminate the unnecessary run-time cost for
>> the !CONFIG_MEMCG at all, and to squash all memcg-related checking
>> into the CONFIG_MEMCG version.
>
> The compiler can easily detect that global_reclaim() always returns
> true for !CONFIG_MEMCG during compile time and not even generate a
> branch for this.
>

Hi, Johannes Weiner,

Thanks for your comment ;)

Andrew has pointed this out and this patch is abandoned.


--

Regards,
Zhan Jianyu
