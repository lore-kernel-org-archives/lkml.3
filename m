Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbbARNIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 08:08:31 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:34849 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbbARNI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 08:08:29 -0500
Message-ID: <54BBB048.7010207@plexistor.com>
Date: Sun, 18 Jan 2015 15:08:24 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Tony Luck <tony.luck@gmail.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/4 v4] brd: Fix all partitions BUGs
References: <54AD5893.9040701@plexistor.com>	<54AD59DC.4020703@plexistor.com> <CA+8MBbJbKwyJJoFy2uyNvR5La3hFac-pSh8mZBV=BnNJzKQMhg@mail.gmail.com> <54B99591.7080007@fb.com>
In-Reply-To: <54B99591.7080007@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2015 12:49 AM, Jens Axboe wrote:
> On 01/16/2015 03:32 PM, Tony Luck wrote:
>> On Wed, Jan 7, 2015 at 8:07 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
>>> From: Boaz Harrosh <boaz@plexistor.com>
>>>
>>> This patch fixes up brd's partitions scheme, now enjoying all worlds.
>>
>> linux-next-20150116 includes this as commit
>> 937af5ecd0591e84ee54180fa97dcbe9bbe5fed6
>>
>> On ia64 I'm seeing:
>> ram0: unknown partition table
>> ram1: unknown partition table
>> ...
>> ram15: unknown partition table
>>
>> At first I blamed c8fa31730fc7 "brd: Request from fdisk 4k alignment" because it
>> has all sorts of comments about PAGE_SIZE and 4k ... and my page size isn't
>> 4k.  But, reverting that one didn't help.
>>
>> reverting 937af5ecd0 does make the message go away.
> 
> Boaz, why wasn't GENHD_FL_SUPPRESS_PARTITION_INFO retained?
> 

OK. This message is completely harmless. My vm's 3 FSfull devices
print this message day in and day out. Its when you have an FS on
a partition-less device.

Dmitry had a module param "show_partition" which controls the addition
of this flag. The reason to remove it is because for some reason
with it, mount by UUID would not work, same reason lsblk would not see
the partition on this device even with -a.

For some reason GENHD_FL_SUPPRESS_PARTITION_INFO does not only shut up
that harmless message above, it interferes with any partition operations.
(As well as any udev operation on the device)

Do you want that I add back Dmitry's "show_partition" module param? Or should
I add a new flag that would behave exactly as a regular device but only
suppress the above harmless and annoying message like:
	GENHD_FL_PARTITION_LESS_OK (Or something like that)

Your call, Tell me which way you want to go. For me the message above is a
daily routine with many other devices not only brd. 
(I would even just remove the message above, what is it for at all? What error
condition does it uncover? So OK I have plugged a new device and it is
uninitialized yet, how the "unknown partition table" helps me in anyway?
I'm not complaining I would really like to understand.)

Thanks
Boaz

