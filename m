Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbaKMKBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:01:05 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41442 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304AbaKMKBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:01:01 -0500
Message-ID: <54648159.8070402@gmail.com>
Date: Thu, 13 Nov 2014 18:00:57 +0800
From: Charles Chiou <ch1102chiou@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V2 PATCH 1/4] scsi:stex.c Support to Pegasus series.
References: <5462D366.5030106@gmail.com> <20141112104300.GA31213@infradead.org>
In-Reply-To: <20141112104300.GA31213@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/12/2014 06:43 PM, Christoph Hellwig wrote:
>> +	u8  yellowstone;
>
> Calling this flag yellowstone seems a bit confusing as there already
> is a st_yel card type, and this only seems a subset of those.  Maybe
> a ->support_pm flag or similar would be useful?
>

OK, I'll modify it.

>> +	u32 subID;
>
> We don't use camelCaps, but I don't think you even need this variable at
> all..
>
>>
>>   	hba->cardtype = (unsigned int) id->driver_data;
>>   	ci = &stex_card_info[hba->cardtype];
>> +	subID = id->subdevice;
>> +	if ((subID == 0x4221 || subID == 0x4222 ||
>> +	    subID == 0x4223 || subID == 0x4224 ||
>> +	    subID == 0x4225 || subID == 0x4226 ||
>> +	    subID == 0x4227 || subID == 0x4261 ||
>> +	    subID == 0x4262 || subID == 0x4263 ||
>> +	    subID == 0x4264 || subID == 0x4265) &&
>> +	    (hba->cardtype == st_yel)) {
>> +		hba->yellowstone = 1;
>> +	} else if (hba->cardtype == st_yel) {
>> +		hba->yellowstone = 0;
>> +	}
>
> Just write this as
>
> 	switch (id->subdevice) {
> 	case 0x4221:
> 	case 0x4222:
> 	case 0x4223:
> 	case 0x4224:
> 	case 0x4225:
> 	case 0x4226:
> 	case 0x4227:
> 	case 0x4261:
> 	case 0x4262:
> 	case 0x4263:
> 	case 0x4264:
> 	case 0x4265:
> 		if (hba->cardtype == st_yel) {
> 			hba->supports_pm = 1;
> 			break;
> 		}
> 	default:
> 		hba->supports_pm = 0;
> 	}
>

OK, I'll correct this. Thank you!

