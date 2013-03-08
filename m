Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab3CHP0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:26:49 -0500
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:53973 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab3CHP0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:26:48 -0500
Message-ID: <513A02FC.4070208@genband.com>
Date: Fri, 08 Mar 2013 09:25:48 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Howard Chu <hyc@symas.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
References: <5136320E.8030109@symas.com> <20130307154312.GG6723@quack.suse.cz> <20130308020854.GC23767@cmpxchg.org> <5139975F.9070509@symas.com> <20130308084246.GA4411@shutemov.name> <5139B214.3040303@symas.com> <5139FA13.8090305@genband.com> <5139FD27.1030208@symas.com>
In-Reply-To: <5139FD27.1030208@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 15:25:50.0043 (UTC) FILETIME=[36D762B0:01CE1C11]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19698.004
X-TM-AS-Result: No--12.365600-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 09:00 AM, Howard Chu wrote:

> First obvious conclusion - kswapd is being too aggressive. When free
> memory hits the low watermark, the reclaim shrinks slapd down from 25GB
> to 18-19GB, while the page cache still contains ~7GB of unmapped pages.
> Ideally I'd like a tuning knob so I can say to keep no more than 2GB of
> unmapped pages in the cache. (And the desired effect of that would be to
> allow user processes to grow to 30GB total, in this case.)
>
> I mentioned this "unmapped page cache control" post already
> http://lwn.net/Articles/436010/ but it seems that the idea was
> ultimately rejected. Is there anything else similar in current kernels?

Sorry, I'm not aware of anything.  I'm not a filesystem/vm guy though, 
so maybe there's something I don't know about.

I would have expected both posix_madvise(..POSIX_MADV_RANDOM) and 
swappiness to help, but it doesn't sound like they're working.

Chris
