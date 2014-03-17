Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbaCQNZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:25:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61372 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaCQNZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:25:41 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5326F7D1.2050800@roeck-us.net>
Date: Mon, 17 Mar 2014 06:25:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>
Subject: Re: [PATCH] spi: sc18is602: Don't be that restrictive with the maximum
 transfer speed
References: <1395020870-18107-1-git-send-email-linux@roeck-us.net> <20140317115256.GC11706@sirena.org.uk>
In-Reply-To: <20140317115256.GC11706@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 04:52 AM, Mark Brown wrote:
> On Sun, Mar 16, 2014 at 06:47:50PM -0700, Guenter Roeck wrote:
>> Commit 09e99bca8 (spi: sc18is602: Convert to let spi core validate
>> transfer speed) made the maximum transfer speed much more restrictive
>> than before. The transfer speed used to be adjusted to 1/4 of the chip
>> clock rate if a higher transfer speed was requested. Now such transfers are
>> simply rejected. With default settings, this causes, for example, a transfer
>> request at 2 mbps to be rejected because the maximum speed with the default
>> chip clock is 1.843 mbps.
>
>> This is unnecessarily restrictive and causes unnecessary failures. Loosen
>> the limit to accept transfers up to 50% of the clock rate and adjust
>> the speed as needed when setting up the actualt transfer.
>
> Given this description I'd expect to see a change in the core not a
> driver - like the other fork of the thread said I'd expect to deal with
> the issue by improving the constraint handling code.
>
Agreed.

>>   	master->transfer_one_message = sc18is602_transfer_one;
>>   	master->dev.of_node = np;
>>   	master->min_speed_hz = hw->freq / 128;
>> -	master->max_speed_hz = hw->freq / 4;
>> +	master->max_speed_hz = hw->freq / 2;
>
> That said, if this is something that the hardware can support it makes
> sense to do it anyway - is there an actual spec constraint available?
>

No, the technical fastest transfer speed is hz / 4, so this would be just an
arbitrary limit to be less restrictive. Axel's patch for the spi core works
perfectly, so I would suggest to go with it if that is acceptable for you.

Thanks,
Guenter

