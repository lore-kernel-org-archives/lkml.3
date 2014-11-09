Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaKIRwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 12:52:25 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49903 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaKIRwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 12:52:23 -0500
Message-ID: <545FA9D4.5080908@plexistor.com>
Date: Sun, 09 Nov 2014 19:52:20 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 4/5] brd: Request from fdisk 4k alignment
References: <545A2D69.8090003@plexistor.com> <545A2F52.3040303@plexistor.com>	<yq1k339enl5.fsf@sermon.lab.mkp.net> <545A379D.30608@plexistor.com> <yq1sihwb5qz.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1sihwb5qz.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 07:25 PM, Martin K. Petersen wrote:
>>>>>> "Boaz" == Boaz Harrosh <boaz@plexistor.com> writes:
> 
> Boaz,
> 
> Boaz> Note that blk_queue_physical_block_size() also trashes io_min, but
> Boaz> we can leave this one to be 512. io_min as opposed to
> Boaz> physical_block_size will actually change Kernel behavior
> 
>>> Care to elaborate?
> 
> I wanted you to elaborate on how io_min changes kernel behavior.
> 

OK You are correct. io_min changes behavior of Kernel in exactly the same
way as physical_block_size.

Through the call to queue_limit_alignment_offset() inside add_partition()
by setting hd_struct->alignment_offset

I do not know why I thought that only io_min does that, I can see now that
both effect the Kernel the same way. Which scares me a bit.

Will I have problems?

<>
> 
> It really sounds like either your fdisk is way too old or you are
> running it in DOS compat mode.
> 
> I don't have a fundamental issue reporting pbs of 4K. But if you are
> only doing it to force a certain partition alignment then it sounds like
> a kernel fix for a userland problem.
> 
> I've CC:ed Karel who can comment on fdisk partition alignment issues.
> 

Thanks Martin. I agree, we should not fix user-mode problems. Please see
the other email with the exact numbers I get from fdisk. It looks like
when everything is 512 like default it would not align my partitions, but
with the 4k-phisical thing it would. What is the expected behavior we want?

Thanks
Boaz

