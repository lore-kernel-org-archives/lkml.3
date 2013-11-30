Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3K3G3M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 01:29:12 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43048 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3K3G3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 01:29:09 -0500
MIME-Version: 1.0
In-Reply-To: <52992659.5040503@gmail.com>
References: <20131129215616.GA32242@rhlx01.hs-esslingen.de>
	<52992659.5040503@gmail.com>
Date: Sat, 30 Nov 2013 11:59:07 +0530
Message-ID: <CAKK=TULveq5m2zX9YQS_v3KUp04qV+XME06tEhFx9upHG7D00w@mail.gmail.com>
Subject: Re: Copying large files eats all of the RAM
From: venkata koppula <vmrkoppula@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for you replies.

Yeah, I understand that we need to utilize the resources as much as we
can. At the same time user should not
feel that system is slow and user should never wait for the copying
operation should complete to launch another
application meanwhile.

If the user is a system administrator or a programmer, he/she
understands the problem and will try to tune the kernel
based on his/her requirements. As an application user(A desktop user
doesn't worry about the optimizations,
even doesn't know what it is:)) faster response is important.

As you said may be the problem is with my hardware. Mine is an acer
laptop with intel core I5 processor with
4GB RAM  and 500 GB HDD(SATA controller, didn't check who the hard
disk manufacturer is). Copying is within
the same hard disk.

I will check if there is any problem with my hardware, but meanwhile
this is the slabinfo (I took a part of slabinfo
what I think is important in this case).

Before the operation:

# name <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>
: tunables <limit> <batchcount> <sharedfactor> : slabdata
<active_slabs> <num_slabs> <sharedavail>

ext4_inode_cache   12469  12469    880   37    8 : tunables    0    0
  0 : slabdata    337    337      0
ext4_io_page        5376   5376     16  256    1 : tunables    0    0
  0 : slabdata     21     21      0


inode_cache         9309   9309    560   29    4 : tunables    0    0
  0 : slabdata    321    321      0
dentry             65549  65919    192   21    1 : tunables    0    0
  0 : slabdata   3139   3139      0

buffer_head        32526  32526    104   39    1 : tunables    0    0
  0 : slabdata    834    834      0


When the copy is going on:

ext4_inode_cache   11298  12543    880   37    8 : tunables    0    0
  0 : slabdata    339    339      0
ext4_io_page       29696  29696     16  256    1 : tunables    0    0
  0 : slabdata    116    116      0


inode_cache         9309   9309    560   29    4 : tunables    0    0
  0 : slabdata    321    321      0
dentry             24787  33054    192   21    1 : tunables    0    0
  0 : slabdata   1574   1574      0
buffer_head       553839 553839    104   39    1 : tunables    0    0
  0 : slabdata  14201  14201      0


I tried Austin S Hemmelgarn suggestion as well, results are as follows.

Same stats with the echo $((16*1024*1024)) >
/proc/sys/vm/dirty_background_bytes.

Before the copy operation:

ext4_inode_cache    5788  10434    880   37    8 : tunables    0    0
  0 : slabdata    282    282      0
ext4_io_page        9734  11264     16  256    1 : tunables    0    0
  0 : slabdata     44     44      0

inode_cache         8258   9251    560   29    4 : tunables    0    0
  0 : slabdata    319    319      0
dentry             17400  24843    192   21    1 : tunables    0    0
  0 : slabdata   1183   1183      0
buffer_head        14425  30966    104   39    1 : tunables    0    0
  0 : slabdata    794    794      0


When the copy is going on:

ext4_inode_cache    4965   9805    880   37    8 : tunables    0    0
  0 : slabdata    265    265      0
ext4_io_page       17708  19456     16  256    1 : tunables    0    0
  0 : slabdata     76     76      0

node_cache         8258   9251    560   29    4 : tunables    0    0
 0 : slabdata    319    319      0
dentry             17052  24738    192   21    1 : tunables    0    0
  0 : slabdata   1178   1178      0
buffer_head       458454 459810    104   39    1 : tunables    0    0
  0 : slabdata  11790  11790      0


I think with this tune system response is fast, no freezes and able to
launch Apps.

Thanks
Venkat

On Sat, Nov 30, 2013 at 5:12 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 11/29/2013 04:56 PM, Andreas Mohr wrote:
>> Hi,
>>
>>> My laptop has 4GB of ram, before I issue the command around 1.5GB of
>>> memory
>>> is used, when I issue the cp command around 3.7GB of memory is used.
>>> And the cp command takes a lot of time to copy.
>>>
>>> I am not able to launch other applications(take a lot of time) and
>>> even compiz freezes frequently. my laptop has Ubuntu installed on it.
>>>
>>> Is this the problem with only my system or it is a common problem with
>>> Linux?.
>>>
>>> Is there any way to stop any copy command to use all of my memory.
>>
>> The purpose of a good operating system is *exactly* to optimize the
>> *all* RAM is used, *all* the time optimum to the highest degree.
>> Or would you want to have your power supply used to power useless
>> memory that's sitting idle?
>>
>> It's probably a good idea to read up on the many sites which explain
>> important OS caching mechanisms.
>>
>> That said, there may of course be situations where too much
>> competition/contention for resources occurs, or where calculation of the
>> kept-free-for-reuse memory amount is sub-optimal, leaving overly scarce
>> amounts of memory available for immediate use.
>> But that should be a matter of optimizing core kernel algorithms
>> even more than they already are.
>>
>> And it's also known that for certain situations (e.g. trying to push very large
>> amounts of data over a lowly USB 1.1 USB stick connection),
>> Linux does (or did?) tend to have issues with that cached data piling up
>> in somewhat negative ways prior to getting flushed over the connection,
>> thereby causing system performance to degrade (I'm not in the know of
>> how much that still applies to very new Linux kernel versions).
>>
>> But in your case that might simply be a problem of your particular
>> hardware (IRQ issues, improperly implemented drivers, ...).
>> Some benchmarking activities might be able to provide more details
>> (e.g. hdparm -tT, bonnie++ results, memory performance tests, etc.).
>>
>> cat /proc/slabinfo
>> ought to provide an initial overview of which cache elements
>> manage to keep the largest memory areas in service.
>>
>
> I think it is more likely hardware related, the USB storage (and other
> slow device) caching issues are related to the actual amount of memory
> in the system (and how slow the device is).  Linux by default caches
> writes up to 10% of system memory prior to starting write-back on a 4G
> system this is only 400M,  the easy way to check though is to try the
> same operation after running:
>         echo $((16*1024*1024)) > /proc/sys/vm/dirty_background_bytes
> this will configure things to start write-back of the data much earlier.
>
> On the other hand, if you are doing this between locations on an SSD,
> that might also be part of the issue, write operations on SSD's take
> much longer than reads, and most of them can't do a read operation while
> the write operation is running (USB flash drives have similar issues,
> which is part of why the caching issues are so evident with them).
