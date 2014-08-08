Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbaHHGwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:52:35 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47460 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaHHGwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140807192032.70e71fa7@alan.etchedpixels.co.uk>
References: <53E21125.9080308@plexistor.com>
	<53E211D9.7030102@plexistor.com>
	<53E3871C.4020008@plexistor.com>
	<20140807192032.70e71fa7@alan.etchedpixels.co.uk>
Date: Fri, 8 Aug 2014 09:52:29 +0300
Message-ID: <CA+uBny4uWrGpb_fNUW5Z6JDw5ZWTG9L5_mh18iMVmDBmmRguaQ@mail.gmail.com>
Subject: Re: [PATCH 2/4 v2] brd: Add getgeo to block ops
From: Boaz Harrosh <boaz@plexistor.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 9:20 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Thu, 07 Aug 2014 17:03:08 +0300
> Boaz Harrosh <boaz@plexistor.com> wrote:
>
>> From: Boaz Harrosh <boaz@plexistor.com>
>>
>> Some programs like fdisk, require HDIO_GETGEO to work, which requires we
>> implement getgeo.
>>
>> We set all hd_geometry members to 1, because this way fdisk
>> math will not try its crazy geometry math and get stuff totally wrong.
>
> If you are running a new storage system for god sake don't use DOS
> partitioning, use GPT or something sane.
>

I am always using GPT, on all my systems for few years now.
Fdisk  works exactly the same, regardless of format, regarding alignment
and start sectors.

Please try before you comment

>> +static int brd_getgeo(struct block_device *bd, struct hd_geometry *geo)
>> +{
>> +     /* Just tell fdisk to get out of the way. The math here is so
>> +      * convoluted and does not make any sense at all. With all 1s
>> +      * The math just gets out of the way.
>> +      * NOTE: I was trying to get some values that will make fdisk
>> +      * Want to align first sector on 4K (like 8, 16, 20, ... sectors) but
>> +      * nothing worked, I searched the net the math is not your regular
>> +      * simple multiplication at all. If you managed to get these please
>> +      * fix here. For now we use 4k physical sectors for this
>> +      */
>> +     geo->heads = 1;
>> +     geo->sectors = 1;
>> +     geo->cylinders = 1;
>> +     return 0;
>
> This is then going to blow up on your with some other tool. Fix fdisk
> instead. Lying to apps generally ends up like children lying to parents -
> the lie gets more complicated to keep up each case you find until it
> breaks.
>

Exactly my point sir. What is heads sectors and cylinders for a RAM
disk. Nothing. We have been lying for  years fearing the world of storage
will explode if we tell the truth. Finally, as you say, our lies came byte us in
the arss. Best is to tell the truth and the math at fdisk will do what it is
suppose to.

And the psychology talk aside, please talk code. Do you know of any
code that will break because of these values above?

I have by now looked at fdisk's code. It will calculate several alignment
constrains and finally pick the biggest one. Also it has code for very
fist sector and different one for other partition-start sectors. This HSC
math above being one of them. With these values HSC becomes very
small and gets out of the way, for the other considerations.
That's fdisk gparted (and parted) will just use 1Mib for alignment which
is very big, and be done with it. I would imagine all other tools use one
library or the other. Do you know otherwise?

Boaz

> Alan
