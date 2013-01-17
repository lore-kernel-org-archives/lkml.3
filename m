Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3AQM7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:59:09 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:38311 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3AQM7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:59:08 -0500
Message-ID: <50F7F58F.30505@ahsoftware.de>
Date: Thu, 17 Jan 2013 13:58:55 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
CC: Axel Lin <axel.lin@ingics.com>, Jonathan Cameron <jic23@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: hid-sensor-time: Add missing spin_lock_init
References: <1358387389.17958.1.camel@phoenix> <CACnwZYfV=czMR=FLwQseubK-G8GnuiVW_wsnFKTnw=rHrZ8dgg@mail.gmail.com>
In-Reply-To: <CACnwZYfV=czMR=FLwQseubK-G8GnuiVW_wsnFKTnw=rHrZ8dgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.01.2013 02:58, schrieb Thiago Farina:
> On Wed, Jan 16, 2013 at 11:49 PM, Axel Lin <axel.lin@ingics.com> wrote:
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> ---
>>   drivers/rtc/rtc-hid-sensor-time.c |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
>> index 0438c9e..31c5728 100644
>> --- a/drivers/rtc/rtc-hid-sensor-time.c
>> +++ b/drivers/rtc/rtc-hid-sensor-time.c
>> @@ -225,6 +225,7 @@ static int hid_time_probe(struct platform_device *pdev)
>>
>>          platform_set_drvdata(pdev, time_state);
>>
>> +       spin_lock_init(&time_state->lock_last_time);
> Can you explain in the commit message why it is missing?
>
> For people not familiar with this code that isn't obvious.
>

Every spinlock must be initialized once (to SPIN_LOCK_UNLOCKED or by 
using spin_lock_init()). On most architectures SPIN_LOCK_UNLOCKED is 
just zero, therefor  the kzalloc of the time_state does it (which likely 
is the case why I haven't spotted any error without the initialization), 
but that doesn't isn't true for all architectures.

Regards,

Alexander

