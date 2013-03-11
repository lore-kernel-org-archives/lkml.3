Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3CKMkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:40:51 -0400
Received: from zill.ext.symas.net ([69.43.206.106]:58569 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3CKMku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:40:50 -0400
Message-ID: <513DD0BD.8000400@symas.com>
Date: Mon, 11 Mar 2013 05:40:29 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0 SeaMonkey/2.19a1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
References: <5136320E.8030109@symas.com> <20130307154312.GG6723@quack.suse.cz> <20130308020854.GC23767@cmpxchg.org> <5139975F.9070509@symas.com> <20130308084246.GA4411@shutemov.name> <5139B214.3040303@symas.com> <5139FA13.8090305@genband.com> <5139FD27.1030208@symas.com> <20130308161643.GE23767@cmpxchg.org> <513A445E.9070806@symas.com> <20130311120427.GC29799@quack.suse.cz>
In-Reply-To: <20130311120427.GC29799@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> On Fri 08-03-13 12:04:46, Howard Chu wrote:
>> The test clearly is accessing only 30GB of data. Once slapd reaches
>> this process size, the test can be stopped and restarted any number
>> of times, run for any number of hours continuously, and memory use
>> on the system is unchanged, and no pageins occur.
>    Interesting. It might be worth trying what happens if you do
> madvise(..., MADV_DONTNEED) on the data file instead of dropping caches
> with /proc/sys/vm/drop_caches. That way we can establish whether the extra
> cached data is in the data file (things will look the same way as with
> drop_caches) or somewhere else (there will be still unmapped page cache).

I screwed up. My madvise(RANDOM) call used the wrong address/len so it didn't 
cover the whole region. After fixing this, the test now runs as expected - the 
slapd process size grows to 30GB without any problem. Sorry for the noise.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
