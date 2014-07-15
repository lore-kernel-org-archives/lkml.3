Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaGORg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:36:57 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:40811 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbaGORgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:36:54 -0400
Message-ID: <53C566AE.50103@iki.fi>
Date: Tue, 15 Jul 2014 20:36:46 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: shuah.kh@samsung.com, m.chehab@samsung.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: em28xx-dvb unregister i2c tuner and demod after
 fe detach
References: <1405093525-8745-1-git-send-email-shuah.kh@samsung.com> <53C1971E.3020200@iki.fi> <53C564F4.8010002@samsung.com>
In-Reply-To: <53C564F4.8010002@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 85.23.164.97
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moikka!

On 07/15/2014 08:29 PM, Shuah Khan wrote:
> On 07/12/2014 02:14 PM, Antti Palosaari wrote:
>> Moikka Shuah!
>> I suspect that patch makes no sense. On DVB there is runtime PM
>> controlled by DVB frontend. It wakes up all FE sub-devices when frontend
>> device is opened and sleeps when closed.
>>
>> FE release() is not relevant at all for those sub-devices which are
>> implemented as a proper I2C client. I2C client has own remove() for that.
>>
>> em28xx_dvb_init and em28xx_dvb_fini are counterparts. Those I2C drivers
>> are load on em28xx_dvb_init so logical place for unload is
>> em28xx_dvb_fini.
>>
>> Is there some real use case you need that change?
>>
>> regards
>> Antti
>>
>
> Hi Antti,
>
> The reason I made this change is because dvb_frontend_detach()
> calls release interfaces for fe as well as tuner. So it made
> sense to move the remove after that is all done. Are you saying
> fe and tuner release calls aren't relevant when sub-devices
> implement a proper i2c client? If that is the case then, and
> there is no chance for these release calls to be invoked when a
> proper i2c is present, then my patch isn't needed.

Yes, that is just case. Proprietary DVB binding model uses attach / 
release, but I2C binding model has probe / remove. I see no reason use 
DVB proprietary model, instead drivers should be converted to kernel I2C 
model.

regards
Antti

-- 
http://palosaari.fi/
