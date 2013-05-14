Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3ENBWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:22:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21995 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab3ENBWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:22:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,666,1363104000"; 
   d="scan'208";a="7260628"
Message-ID: <5191926A.2090608@cn.fujitsu.com>
Date: Tue, 14 May 2013 09:24:58 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>, Jeff Moyer <jmoyer@redhat.com>,
        Mel Gorman <mgorman@suse.de>
CC: Minchan Kim <minchan@kernel.org>, Lin Feng <linfeng@cn.fujitsu.com>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, rientjes@google.com,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, jiang.liu@huawei.com, zab@redhat.com,
        linux-mm@kvack.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH V2 1/2] mm: hotplug: implement non-movable version of
 get_user_pages() called get_user_pages_non_movable()
References: <1360056113-14294-1-git-send-email-linfeng@cn.fujitsu.com> <1360056113-14294-2-git-send-email-linfeng@cn.fujitsu.com> <20130205120137.GG21389@suse.de> <20130206004234.GD11197@blaptop> <20130206095617.GN21389@suse.de> <5190AE4F.4000103@cn.fujitsu.com> <20130513091902.GP11497@suse.de> <20130513143757.GP31899@kvack.org> <x49obcfnd6c.fsf@segfault.boston.devel.redhat.com> <20130513150147.GQ31899@kvack.org>
In-Reply-To: <20130513150147.GQ31899@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 09:20:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 09:20:58,
	Serialize complete at 2013/05/14 09:20:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel, Benjamin, Jeff,

On 05/13/2013 11:01 PM, Benjamin LaHaise wrote:
> On Mon, May 13, 2013 at 10:54:03AM -0400, Jeff Moyer wrote:
>> How do you propose to move the ring pages?
>
> It's the same problem as doing a TLB shootdown: flush the old pages from
> userspace's mapping, copy any existing data to the new pages, then
> repopulate the page tables.  It will likely require the addition of
> address_space_operations for the mapping, but that's not too hard to do.
>

I think we add migrate_unpin() callback to decrease page->count if 
necessary,
and migrate the page to a new page, and add migrate_pin() callback to pin
the new page again.

The migrate procedure will work just as before. We use callbacks to 
decrease
the page->count before migration starts, and increase it when the migration
is done.

And migrate_pin() and migrate_unpin() callbacks will be added to
struct address_space_operations.

Is that right ?

If so, I'll be working on it.

Thanks. :)
