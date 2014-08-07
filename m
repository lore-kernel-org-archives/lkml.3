Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbaHGN5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:57:23 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58541 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457AbaHGN5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:57:22 -0400
Message-ID: <53E385BE.40100@plexistor.com>
Date: Thu, 07 Aug 2014 16:57:18 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>, Boaz Harrosh <openosd@gmail.com>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/4] brd: Request from fdisk 4k alignment
References: <53E21125.9080308@plexistor.com> <53E21317.7080403@plexistor.com> <1407362634.2869.2.camel@rzwisler-mobl1.amr.corp.intel.com> <53E36E53.3090008@gmail.com> <20140807130042.GB9401@x2.net.home>
In-Reply-To: <20140807130042.GB9401@x2.net.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 04:00 PM, Karel Zak wrote:
> On Thu, Aug 07, 2014 at 03:17:23PM +0300, Boaz Harrosh wrote:
> 
>>> Is there an error case that this patch fixes?  I've had page alignment checks
>>> in my PRD direct_access code forever, and I don't know if they've ever
>>> tripped.  
>>>
>>
>> Yes! as I said above fix fdisk. You never tripped on it because partitions never
>> worked and you never tried them. With current code fdisk is very trigger happy
> 
>  What do you mean with fdisk? which version?
> 

fdisk from util-linux 2.24.2


>  The current fdisk (and cfdisk) follows I/O limits it has no problem
>  with 4K devices. All you need is to provide all necessary information 
>  by /sys (or ioctls).
> 

I was not saying that fdisk is wrong. I was saying that if my block driver
was *not* exporting 4K physical sectors through limits.physical_block_size
then fdisk would be happy to not align my partition start on 4k and would
give me funny values like 34 for first sector which makes my device unusable
because in direct_access() API we must absolutely have 4K aligned partitions.

>> to miss-align my partitions. Depending on size maybe not the very first one but the
>> consecutive ones easily.
> 
>  it would be nice to have usable bug report...
> 

Hi Karel

Setting limits.physical_block_size = 4k; was the only way I found that could cause
fdisk to default to 4k alignment.

I was trying to play with the  heads, sectors, cylinders; values but none I tried
would cause an alignment of 4k, not even of the first partition start.

Please advise what I can do?

Thanks
Boaz

>     Karel
> 

