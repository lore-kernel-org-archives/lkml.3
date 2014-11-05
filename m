Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaKEOs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:48:59 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39785 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaKEOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:48:58 -0500
Message-ID: <545A379D.30608@plexistor.com>
Date: Wed, 05 Nov 2014 16:43:41 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Boaz Harrosh <boaz@plexistor.com>
CC: Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/5] brd: Request from fdisk 4k alignment
References: <545A2D69.8090003@plexistor.com> <545A2F52.3040303@plexistor.com> <yq1k339enl5.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1k339enl5.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 04:20 PM, Martin K. Petersen wrote:
>>>>>> "Boaz" == Boaz Harrosh <boaz@plexistor.com> writes:
> 
> Hey Boaz,
> 
> Boaz> Note that blk_queue_physical_block_size() also trashes io_min, but
> Boaz> we can leave this one to be 512. io_min as opposed to
> Boaz> physical_block_size will actually change Kernel behavior
> 
> Care to elaborate?
> 
> Boaz> before this patch running fdisk on a default size brd of 4M
> Boaz> the first sector offered is 34 (BAD), but after this patch it
> Boaz> will be 40, ie 8 sectors aligned. Also when entering some random
> Boaz> partition sizes the next partition-start sector is offered 8 sectors
> Boaz> aligned after this patch. (Please note that with fdisk the user
> Boaz> can still enter bad values, only the offered default values will
> Boaz> be correct)

I did elaborate, Please try with these numbers above and see for
yourself. (Summery brd-size=4M before this patch will offer 34 as
first-sector, after 40)

> Also, fdisk and parted should be aligning on 1MB by default regardless
> of block size. So I'm also not sure why you need to trick fdisk to align
> by setting the pbs.
> 

fdisk will not align partition-start on 1M, only the very first-sector,
libgparted and cfdisk are as you say, but with fdisk if you put any odd
numbered partition-size, the next start-sector will just be the sum, but
with this patch it will offer a small hole and will align the
partition-start on 4K.
(And even with this patch user can enter bad values)

Please believe me that I did not try to invent work for myself. I wanted
to fix the partition bugs, with the use of direct_access and to my dismay
I found that it is very easy to have broken partition alignments. With this
patch it is still possible but mach harder to do so.

Thanks
Boaz

