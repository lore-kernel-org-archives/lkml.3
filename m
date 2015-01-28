Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbbA2BmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:42:07 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:41609 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbA2BmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:42:03 -0500
Message-ID: <54C8EF16.5080701@gmail.com>
Date: Wed, 28 Jan 2015 09:15:50 -0500
From: John Moser <john.r.moser@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
CC: linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: OOM at low page cache?
References: <54C2C89C.8080002@gmail.com> <54C77086.7090505@suse.cz> <20150128062609.GA4706@blaptop>
In-Reply-To: <20150128062609.GA4706@blaptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 01:26 AM, Minchan Kim wrote:
> Hello,
>
> On Tue, Jan 27, 2015 at 12:03:34PM +0100, Vlastimil Babka wrote:
>> CC linux-mm in case somebody has a good answer but missed this in lkml traffic
>>
>> On 01/23/2015 11:18 PM, John Moser wrote:
>>> Why is there no tunable to OOM at low page cache?
> AFAIR, there were several trial although there wasn't acceptable
> at that time. One thing I can remember is min_filelist_kbytes.
> FYI, http://lwn.net/Articles/412313/
>

That looks more straight-forward than http://lwn.net/Articles/422291/


> I'm far away from reclaim code for a long time but when I read again,
> I found something strange.
>
> With having swap in get_scan_count, we keep a mount of file LRU + free
> as above than high wmark to prevent file LRU thrashing but we don't
> with no swap. Why?
>

That's ... strange.  That means having a token 1MB swap file changes the
system's practical memory reclaim behavior dramatically?
