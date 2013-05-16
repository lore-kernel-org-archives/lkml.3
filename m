Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3EPFv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 01:51:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13111 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab3EPFv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 01:51:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,681,1363104000"; 
   d="scan'208";a="7283301"
Message-ID: <5194748A.5070700@cn.fujitsu.com>
Date: Thu, 16 May 2013 13:54:18 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Minchan Kim <minchan@kernel.org>, Lin Feng <linfeng@cn.fujitsu.com>,
        akpm@linux-foundation.org, bcrl@kvack.org, viro@zeniv.linux.org.uk,
        khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        jmoyer@redhat.com, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of
 get_user_pages() called get_user_pages_non_movable()
References: <1360056113-14294-1-git-send-email-linfeng@cn.fujitsu.com> <1360056113-14294-2-git-send-email-linfeng@cn.fujitsu.com> <20130205120137.GG21389@suse.de> <20130206004234.GD11197@blaptop> <20130206095617.GN21389@suse.de> <5190AE4F.4000103@cn.fujitsu.com> <20130513091902.GP11497@suse.de> <5191B5B3.7080406@cn.fujitsu.com> <20130515132453.GB11497@suse.de>
In-Reply-To: <20130515132453.GB11497@suse.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/16 13:50:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/16 13:50:16,
	Serialize complete at 2013/05/16 13:50:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On 05/15/2013 09:24 PM, Mel Gorman wrote:
> If it is to be an address space operations sturcture then you'll need a
> pseudo mapping structure for anonymous pages that are pinned by aio --
> similar in principal to how swapper_space is used for managing PageSwapCache
> or how anon_vma structures can be associated with a page.
>
> However, I warn you that you may find that the address_space is the
> wrong level to register such callbacks, it just seemed like the obvious
> first choice. A potential alternative implementation is to create a 1:1
> association between pages and a long-lived holder that is stored on a hash
> table (similar style of arrangement as page_waitqueue).  A page is looked up
> in the hash table and if an entry exists, it points to an callback structure
> to the subsystem holding the pin. It's up to the subsystem to register the
> callbacks when it is about to pin a page (get_user_pages_longlived(....,
> &release_ops) and figure out how to release the pin safely.
>

OK, I'll try to figure out a proper place to put the callbacks.
But I think we need to add something new to struct page. I'm just
not sure if it is OK. Maybe we can discuss more about it when I send
a RFC patch.

Thanks for the advices, and I'll try them.

Thanks. :)
