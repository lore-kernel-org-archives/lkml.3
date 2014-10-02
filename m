Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaJBX6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 19:58:52 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:45612 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaJBX6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 19:58:51 -0400
Message-ID: <542DE6B5.1060906@iki.fi>
Date: Fri, 03 Oct 2014 02:58:45 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Amber Thrall <amber.rose.thrall@gmail.com>, jarod@wilsonet.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixed all coding style issues for drivers/staging/media/lirc/
References: <1412224802-28431-1-git-send-email-amber.rose.thrall@gmail.com>	 <20141002102938.2b762583@recife.lan> <1412268351.3247.68.camel@joe-AO725>
In-Reply-To: <1412268351.3247.68.camel@joe-AO725>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.191.243
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/02/2014 07:45 PM, Joe Perches wrote:
> On Thu, 2014-10-02 at 10:29 -0300, Mauro Carvalho Chehab wrote:
>> Em Wed, 01 Oct 2014 21:40:02 -0700 Amber Thrall <amber.rose.thrall@gmail.com> escreveu:
>>> Fixed various coding style issues, including strings over 80 characters long and many
>>> deprecated printk's have been replaced with proper methods.
> []
>>> diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
> []
>>> @@ -623,8 +623,8 @@ static void imon_incoming_packet(struct imon_context *context,
>>>   	if (debug) {
>>>   		dev_info(dev, "raw packet: ");
>>>   		for (i = 0; i < len; ++i)
>>> -			printk("%02x ", buf[i]);
>>> -		printk("\n");
>>> +			dev_info(dev, "%02x ", buf[i]);
>>> +		dev_info(dev, "\n");
>>>   	}
>>
>> This is wrong, as the second printk should be printk_cont.
>>
>> The best here would be to change all above to use %*ph.
>> So, just:
>>
>> 	dev_debug(dev, "raw packet: %*ph\n", len, buf);
>
> Not quite.
>
> %*ph is length limited and only useful for lengths < 30 or so.
> Even then, it's pretty ugly.
>
> print_hex_dump_debug() is generally better.

That is place where you print 8 debug bytes, which are received remote 
controller code. IMHO %*ph format is just what you like in that case.

Why print_hex_dump_debug() is better? IIRC it could not be even 
controlled like those dynamic debug printings.

regards
Antti

-- 
http://palosaari.fi/
