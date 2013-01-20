Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3ATMCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 07:02:22 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:41548 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3ATMCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 07:02:20 -0500
Message-ID: <50FBDCCA.1030604@kernel.org>
Date: Sun, 20 Jan 2013 12:02:18 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Axel Lin <axel.lin@ingics.com>, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: hid-sensor-time: Add missing spin_lock_init
References: <1358387389.17958.1.camel@phoenix> <50F7F2F7.9010900@ahsoftware.de>
In-Reply-To: <50F7F2F7.9010900@ahsoftware.de>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 12:47 PM, Alexander Holler wrote:
> Am 17.01.2013 02:49, schrieb Axel Lin:
> 
> Thanks, yes, I missed it the initialization of the spinlock.
> 
> Below is my ack.
> 
> Regards,
> 
> Alexander
> 
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> Acked-by: Alexander Holler <holler@ahsoftware.de>
Applied to togreg branch of iio.git.

Thanks,
> 
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
>>       platform_set_drvdata(pdev, time_state);
>>
>> +    spin_lock_init(&time_state->lock_last_time);
>>       init_completion(&time_state->comp_last_time);
>>       time_state->common_attributes.hsdev = hsdev;
>>       time_state->common_attributes.pdev = pdev;
>>
> 
