Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3K2XmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 18:42:25 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62468 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab3K2XmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 18:42:20 -0500
Message-ID: <52992659.5040503@gmail.com>
Date: Fri, 29 Nov 2013 18:42:17 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>, venkata koppula <vmrkoppula@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Copying large files eats all of the RAM
References: <20131129215616.GA32242@rhlx01.hs-esslingen.de>
In-Reply-To: <20131129215616.GA32242@rhlx01.hs-esslingen.de>
X-Enigmail-Version: 1.6
OpenPGP: id=85D2EC0F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2013 04:56 PM, Andreas Mohr wrote:
> Hi,
> 
>> My laptop has 4GB of ram, before I issue the command around 1.5GB of
>> memory
>> is used, when I issue the cp command around 3.7GB of memory is used.
>> And the cp command takes a lot of time to copy.
>>
>> I am not able to launch other applications(take a lot of time) and
>> even compiz freezes frequently. my laptop has Ubuntu installed on it.
>>
>> Is this the problem with only my system or it is a common problem with
>> Linux?.
>>
>> Is there any way to stop any copy command to use all of my memory.
> 
> The purpose of a good operating system is *exactly* to optimize the
> *all* RAM is used, *all* the time optimum to the highest degree.
> Or would you want to have your power supply used to power useless
> memory that's sitting idle?
> 
> It's probably a good idea to read up on the many sites which explain
> important OS caching mechanisms.
> 
> That said, there may of course be situations where too much
> competition/contention for resources occurs, or where calculation of the
> kept-free-for-reuse memory amount is sub-optimal, leaving overly scarce
> amounts of memory available for immediate use.
> But that should be a matter of optimizing core kernel algorithms
> even more than they already are.
> 
> And it's also known that for certain situations (e.g. trying to push very large
> amounts of data over a lowly USB 1.1 USB stick connection),
> Linux does (or did?) tend to have issues with that cached data piling up
> in somewhat negative ways prior to getting flushed over the connection,
> thereby causing system performance to degrade (I'm not in the know of
> how much that still applies to very new Linux kernel versions).
> 
> But in your case that might simply be a problem of your particular
> hardware (IRQ issues, improperly implemented drivers, ...).
> Some benchmarking activities might be able to provide more details
> (e.g. hdparm -tT, bonnie++ results, memory performance tests, etc.).
> 
> cat /proc/slabinfo
> ought to provide an initial overview of which cache elements
> manage to keep the largest memory areas in service.
> 

I think it is more likely hardware related, the USB storage (and other
slow device) caching issues are related to the actual amount of memory
in the system (and how slow the device is).  Linux by default caches
writes up to 10% of system memory prior to starting write-back on a 4G
system this is only 400M,  the easy way to check though is to try the
same operation after running:
	echo $((16*1024*1024)) > /proc/sys/vm/dirty_background_bytes
this will configure things to start write-back of the data much earlier.

On the other hand, if you are doing this between locations on an SSD,
that might also be part of the issue, write operations on SSD's take
much longer than reads, and most of them can't do a read operation while
the write operation is running (USB flash drives have similar issues,
which is part of why the caching issues are so evident with them).
