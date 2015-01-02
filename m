Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbbABL3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 06:29:02 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbbABL3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 06:29:00 -0500
Message-ID: <54A680F8.30209@nod.at>
Date: Fri, 02 Jan 2015 12:28:56 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: harald@ccbib.org, Jonathan Cameron <jic23@kernel.org>
CC: knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: iio: dht11 Updates
References: <1417563176-31972-1-git-send-email-richard@nod.at> <54A53FBF.5000003@kernel.org> <7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net>
In-Reply-To: <7e4f6a70e48afe96457ebbcf07572224@imap.cosmopool.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.01.2015 um 22:18 schrieb harald@ccbib.org:
> Hi!
> 
> On Thu, 01 Jan 2015 12:38:23 +0000, Jonathan Cameron <jic23@kernel.org>
> wrote:
>> On 02/12/14 23:32, Richard Weinberger wrote:
>>> Please see my current patches for your driver.
>>> As discussed in an earlier mail I'm testing with the DHT22 sensor only.
>>> With the IRQ changes I see 84 edges.
>>>
>>>
>>> [PATCH 1/4] iio: dht11: Add locking
>>> [PATCH 2/4] iio: dht11: IRQ fixes
>>> [PATCH 3/4] iio: dht11: Logging updates
>>> [PATCH 4/4] iio: dht11: Fix out-of-bounds read
>>>
>  
>> I've lost track of where we are with this patch series.
>> Does this cause trouble on any of the parts supported?
> 
> Yes, 2/4 needs an update. 

Correct.

> 1/4 is fine by me, however it was noted that there is already
> locking in the iio core for the in-kernel interface but not
> for the sysfs interface. I think we need locking in the case of
> the sysfs interace as well, but the final decision is yours...

We definitely need it.
I have more than one sensor attached and collectd queries them.
Without locking collectd manages to hit this race window.
So the issue is real.

> 4/4 is obviously right.
> 
> 3/4 is cleanup. I'd rather defer this to later and do it right,
> because right now this patch is cosmetic and doesn't get rid of
> the deeper issues. I'll start to work on a cleanup series once
> the fixes are merged.

Agreed.

> Richard, what's your timeframe to send an updated series?
> I can send an update if you don't have time.

It would be great if you can send an updated version of 2/4.
I don't have a DHT11 sensor (only DHT22) and I'm still recovering
from a cold.

Thanks
//richard
