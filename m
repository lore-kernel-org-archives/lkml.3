Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbaDWHXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:23:48 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44007 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097AbaDWHXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:23:45 -0400
Message-ID: <53576A7D.9020303@gmail.com>
Date: Wed, 23 Apr 2014 09:23:41 +0200
From: Ivan Pantovic <gyro.ivan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Speedy Milan <speedy.milan@gmail.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: rm -f * on large files very slow on XFS + MD RAID 6 volume of
 15x 4TB of HDDs (52TB)
References: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com> <20140423021835.GI15995@dastard>
In-Reply-To: <20140423021835.GI15995@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> [root@drive-b ~]# xfs_db -r /dev/md0
> xfs_db> frag
> actual 11157932, ideal 11015175, fragmentation factor 1.28%
> xfs_db>

this is current level of fragmentation ... is it bad?

some say over 1% is candidate for defrag? ...

we can leave it like this and wait for a next full backup and then check 
on the fragmentation of that file.

On 04/23/2014 04:18 AM, Dave Chinner wrote:
> [cc xfs@oss.sgi.com]
>
> On Mon, Apr 21, 2014 at 10:58:53PM +0200, Speedy Milan wrote:
>> I want to report very slow deletion of 24 50GB files (in total 12 TB),
>> all present in the same folder.
> total = 1.2TB?
>
>> OS is CentOS 6.4, with upgraded kernel 3.13.1.
>>
>> The hardware is a Supermicro server with 15x 4TB WD Se drives in MD
>> RAID 6, totalling 52TB of free space.
>>
>> XFS is formated directly on the RAID volume, without LVM layers.
>>
>> Deletion was done with rm -f * command, and it took upwards of 1 hour
>> to delete the files.
>>
>> File system was filled completely prior to deletion.
> Oh, that's bad. it's likely you fragmented the files into
> millions of extents?
>
>> rm was mostly waiting (D state), probably for kworker threads, and
> No, waiting for IO.
>
>> iostat was showing big HDD utilization numbers and very low throughput
>> so it looked like a random HDD workload was in effect.
> Yup, smells like file fragmentation. Non-fragmented 50GB files
> should be removed in a few milliseconds. but if you've badly
> fragmented the files, there could be 10 million extents in a 50GB
> file. A few milliseconds per extent removal gives you....
>
> Cheers,
>
> Dave.

