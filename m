Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaHGPku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:40:50 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47603 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaHGPkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:40:49 -0400
Message-ID: <53E39DFE.6050501@plexistor.com>
Date: Thu, 07 Aug 2014 18:40:46 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Boaz Harrosh <openosd@gmail.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/4] brd: Request from fdisk 4k alignment
References: <53E21125.9080308@plexistor.com> <53E21317.7080403@plexistor.com> <1407362634.2869.2.camel@rzwisler-mobl1.amr.corp.intel.com> <53E36E53.3090008@gmail.com> <20140807130042.GB9401@x2.net.home> <53E385BE.40100@plexistor.com> <20140807152112.GD9401@x2.net.home>
In-Reply-To: <20140807152112.GD9401@x2.net.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 06:21 PM, Karel Zak wrote:
<>
> 
>  fdisk uses physical sector size or minimal I/O size (greater value wins)
> 

OK

>> I was trying to play with the  heads, sectors, cylinders; values but none I tried
> 
>  don't play with CHS, that's waste of time and it's completely ignored
>  by fdisk by default
> 
>> would cause an alignment of 4k, not even of the first partition start.
>>
>> Please advise what I can do?
> 
>  IMHO you're right with your patch (alignment offset is IMHO bad way).
>  It's all (brd) about pages, is there any reason to use something else
>  for I/O limits?
> 
>  It would be also nice to set minimal and optimal io size, zero values
>  in this case means (for userspace) that the device does not provide
>  any I/O information to system. It's normal for old hw disks and then
>  we use some built-in defaults, but I don't see a reason to do the
>  same for virtual devices. 
> 

Hi Ross

I have by now read the all code, and Karel also confirms this from fdisk
side. The best for us is the use of "physical sector size" but with
our "minimal I/O size" set to 512. The later has actual bad effects in
the Kernel code itself. But the "physical sector size" has no effect on
Kernel code, and actually has a very good affect on fdisk which now works
the way we would like it.

Please send your review-by so Jens can pick these up for mainline

>     Karel
> 

Thanks
Boaz

