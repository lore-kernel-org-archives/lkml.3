Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3EXPf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 11:35:29 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:57592 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab3EXPf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 11:35:28 -0400
Message-ID: <519F88EA.2080305@gmail.com>
Date: Fri, 24 May 2013 17:36:10 +0200
From: Federico Manzan <f.manzan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@linuxfoundation.org, sarah.a.sharp@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbfs: Increase arbitrary limit for USB 3 isopkt length
References: <Pine.LNX.4.44L0.1305240946410.1238-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1305240946410.1238-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 03:51 PM, Alan Stern wrote:
>> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
>> index caefc80..7ac137e 100644
>> --- a/drivers/usb/core/devio.c
>> +++ b/drivers/usb/core/devio.c
>> @@ -1287,9 +1287,11 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
>>   			goto error;
>>   		}
>>   		for (totlen = u = 0; u<  uurb->number_of_packets; u++) {
>> -			/* arbitrary limit,
>> -			 * sufficient for USB 2.0 high-bandwidth iso */
>> -			if (isopkt[u].length>  8192) {
>> +			/* arbitrary limit need for USB 3.0
>> +			 * bMaxBurst (0~15 allowed, 1~16 packets)
>> +			 * bmAttributes (bit 1:0, mult 0~2, 1~3 packets)
>> +			 * sizemax: 1024 * 16 * 3 = 49152*/
>> +			if (isopkt[u].length>  65536) {
>>   				ret = -EINVAL;
>>   				goto error;
>>   			}
> A couple of suggestions for improvements:
>
> First, new or updated multi-line comments should follow the accepted
> formatting standard:
>
> 	/*
> 	 * Start comment here...
> 	 * and end here.
> 	 */
ok, I change the comment in the suggested way
> Second, it's confusing for the comment to mention that the limit is
> 49152 and the code to set the limit to 65536.  They should agree on a
> single value (probably 49152).
>
In the USB 2 isochronous the limit is 1024 byte x 3 pkts = 3072, but in 
the code is write 8192. I don't understand why, for the memory page 
size? for have a tolerant limits? for rounding to a nice number?
So I wrote a limit some more big and round, but I agree with you the 
best way is write the correct limit, so I modify in this way, soon.

Federico Manzan

