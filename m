Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960Ab3CHJkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:40:46 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:51894 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383Ab3CHJko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:40:44 -0500
Message-ID: <5139B214.3040303@symas.com>
Date: Fri, 08 Mar 2013 01:40:36 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0 SeaMonkey/2.19a1
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
References: <5136320E.8030109@symas.com> <20130307154312.GG6723@quack.suse.cz> <20130308020854.GC23767@cmpxchg.org> <5139975F.9070509@symas.com> <20130308084246.GA4411@shutemov.name>
In-Reply-To: <20130308084246.GA4411@shutemov.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> On Thu, Mar 07, 2013 at 11:46:39PM -0800, Howard Chu wrote:
>> You're misreading the information then. slapd is doing no caching of
>> its own, its RSS and SHR memory size are both the same. All it is
>> using is the mmap, nothing else. The RSS == SHR == FS cache, up to
>> 16GB. RSS is always == SHR, but above 16GB they grow more slowly
>> than the FS cache.
>
> It only means, that some pages got unmapped from your process. It can
> happned, for instance, due page migration. There's nothing worry about: it
> will be mapped back on next page fault to the page and it's only minor
> page fault since the page is in pagecache anyway.

Unfortunately there *is* something to worry about. As I said already - when 
the test spans 30GB, the FS cache fills up the rest of RAM and the test is 
doing a lot of real I/O even though it shouldn't need to. Please, read the 
entire original post before replying.

There is no way that a process that is accessing only 30GB of a mmap should be 
able to fill up 32GB of RAM. There's nothing else running on the machine, I've 
killed or suspended everything else in userland besides a couple shells 
running top and vmstat. When I manually drop_caches repeatedly, then 
eventually slapd RSS/SHR grows to 30GB and the physical I/O stops.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
