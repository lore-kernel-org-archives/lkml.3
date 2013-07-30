Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab3G3Nsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:48:46 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:26102 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab3G3Nso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:48:44 -0400
Message-ID: <51F7C433.6070005@atmel.com>
Date: Tue, 30 Jul 2013 14:48:35 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@linuxdriverproject.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: ozwpan: High resolution timers
References: <1375187510-28042-1-git-send-email-rupesh.gujare@atmel.com> <20130730131230.GC5002@mwanda>
In-Reply-To: <20130730131230.GC5002@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/07/13 14:12, Dan Carpenter wrote:
> On Tue, Jul 30, 2013 at 01:31:50PM +0100, Rupesh Gujare wrote:
>> Current implementation assumes HZ = 1000 for calculating
>> all internal timer intervals, which creates problem on
>> platforms where HZ != 1000.
>>
>> As well we need resolution of less than 10 mSec for heartbeat
>> calculation, this creates problem on some platforms where HZ is
>> configured as HZ = 100, or around, which restricts us to timer interval
>> of 10 mSec. This is particularly found on embedded devices.
>>
>> This patch moves on to use high resolution timers to calculate
>> all timer intervals as it allows us to have very small resolution
>> of timer interval, removing dependency on HZ.
>>
> I am new to this driver.  So we batch all the transfers together and
> send/recieve them in oz_hcd_heartbeat() every 10msec?  It's a
> polling interface?
>
> Sorry, if I am completely mis-reading what this driver is doing.
>
> In other words, could you explain what oz_hcd_heartbeat() does.
>
>
>

Yes, you are right. USB service requests for regular heartbeat when it 
have URBs queued (at them moment every 8mSsec when ISOC endpoints are
configured). This heartbeat is also used by EP0 traffic to retransmit 
packet over WiFi.

At heartbeat expiry, oz_hcd_heartbeat(), goes on to process all received 
URBs and send it over WiFi.


-- 
Regards,
Rupesh Gujare

