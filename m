Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbbADLB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 06:01:58 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48198 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbbADLB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 06:01:56 -0500
Message-ID: <54A91DA1.6080107@kernel.org>
Date: Sun, 04 Jan 2015 11:01:53 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, harald@ccbib.org
CC: knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: iio: dht11 Updates
References: <1417563176-31972-1-git-send-email-richard@nod.at> <54A53FBF.5000003@kernel.org> <7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net> <54A680F8.30209@nod.at>
In-Reply-To: <54A680F8.30209@nod.at>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/15 11:28, Richard Weinberger wrote:
> Am 01.01.2015 um 22:18 schrieb harald@ccbib.org:
>> Hi!
>>
>> On Thu, 01 Jan 2015 12:38:23 +0000, Jonathan Cameron <jic23@kernel.org>
>> wrote:
>>> On 02/12/14 23:32, Richard Weinberger wrote:
>>>> Please see my current patches for your driver.
>>>> As discussed in an earlier mail I'm testing with the DHT22 sensor only.
>>>> With the IRQ changes I see 84 edges.
>>>>
>>>>
>>>> [PATCH 1/4] iio: dht11: Add locking
>>>> [PATCH 2/4] iio: dht11: IRQ fixes
>>>> [PATCH 3/4] iio: dht11: Logging updates
>>>> [PATCH 4/4] iio: dht11: Fix out-of-bounds read
>>>>
>>  
>>> I've lost track of where we are with this patch series.
>>> Does this cause trouble on any of the parts supported?
>>
>> Yes, 2/4 needs an update. 
> 
> Correct.
> 
>> 1/4 is fine by me, however it was noted that there is already
>> locking in the iio core for the in-kernel interface but not
>> for the sysfs interface. I think we need locking in the case of
>> the sysfs interace as well, but the final decision is yours...
> 
> We definitely need it.
> I have more than one sensor attached and collectd queries them.
> Without locking collectd manages to hit this race window.
> So the issue is real.
Locking is needed.  Convention has normally been to do this in the
driver rather than a subsystem core.
That gives more fine grained control and avoids locking
when not necessary (some devices will need a lock on data read,
others will not).
Clearly in this case, the need should have been picked up in review
(oops).  Sorry about that.
> 
>> 4/4 is obviously right.
>>
>> 3/4 is cleanup. I'd rather defer this to later and do it right,
>> because right now this patch is cosmetic and doesn't get rid of
>> the deeper issues. I'll start to work on a cleanup series once
>> the fixes are merged.
> 
> Agreed.
> 
>> Richard, what's your timeframe to send an updated series?
>> I can send an update if you don't have time.
> 
> It would be great if you can send an updated version of 2/4.
> I don't have a DHT11 sensor (only DHT22) and I'm still recovering
> from a cold.
> 
> Thanks
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

