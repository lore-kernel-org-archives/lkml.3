Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247Ab3CHOsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 09:48:46 -0500
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:37862 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab3CHOsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 09:48:45 -0500
Message-ID: <5139FA13.8090305@genband.com>
Date: Fri, 08 Mar 2013 08:47:47 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Howard Chu <hyc@symas.com>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
References: <5136320E.8030109@symas.com> <20130307154312.GG6723@quack.suse.cz> <20130308020854.GC23767@cmpxchg.org> <5139975F.9070509@symas.com> <20130308084246.GA4411@shutemov.name> <5139B214.3040303@symas.com>
In-Reply-To: <5139B214.3040303@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 14:47:48.0507 (UTC) FILETIME=[E6F09EB0:01CE1C0B]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19698.004
X-TM-AS-Result: No--7.989000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2013 03:40 AM, Howard Chu wrote:

> There is no way that a process that is accessing only 30GB of a mmap
> should be able to fill up 32GB of RAM. There's nothing else running on
> the machine, I've killed or suspended everything else in userland
> besides a couple shells running top and vmstat. When I manually
> drop_caches repeatedly, then eventually slapd RSS/SHR grows to 30GB and
> the physical I/O stops.

Is it possible that the kernel is doing some sort of automatic 
readahead, but it ends up reading pages corresponding to data that isn't 
ever queried and so doesn't get mapped by the application?

Chris
