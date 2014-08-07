Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbaHGJUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:20:35 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46997 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaHGJUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:20:34 -0400
Message-ID: <53E344DD.7020801@gmail.com>
Date: Thu, 07 Aug 2014 12:20:29 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Boaz Harrosh <boaz@plexistor.com>
CC: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/4] brd: Add getgeo to block ops
References: <53E21125.9080308@plexistor.com> <53E211D9.7030102@plexistor.com> <alpine.OSX.2.00.1408061150120.23481@scrumpy>
In-Reply-To: <alpine.OSX.2.00.1408061150120.23481@scrumpy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 08:52 PM, Ross Zwisler wrote:
> On Wed, 6 Aug 2014, Boaz Harrosh wrote:
>> From: Ross Zwisler <ross.zwisler@linux.intel.com>
>>
>> Some programs require HDIO_GETGEO work, which requires we implement
>> getgeo.  Based off of the work done to the NVMe driver in this commit:
>>
<>
>> +static int brd_getgeo(struct block_device *bd, struct hd_geometry *geo)
>> +{
>> +	/* some standard values */
>> +	geo->heads = 1 << 6;
>> +	geo->sectors = 1 << 5;
>> +	geo->cylinders = get_capacity(bd->bd_disk) >> 11;
>> +	return 0;
>> +}
>> +
<> 
> This looks good.
> 

Actually this one is wrong. When I go into fdisk it always gives me
34 as the first possible sector. (And with my 4k patch it gives me
40)

But what I really want is just plain 8. All I want is to waist first
4k for partition table and enough is enough. So actually this above
is wrong.

All we need is :
+	geo->heads = 1 ;
+	geo->sectors = 1 ;
+	geo->cylinders = 1;

Now do not worry the capacity is never extracted from this 32bit structure
for a long time. The capacity is fetched else where, in all programs. This
here just gives you that wired HD math calculation for this 34 sectors
alignment crap.

I just tried it works perfectly with fdisk and gpart. So I'll post a patch.

Thanks
Boaz

