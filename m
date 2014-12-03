Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaLCWFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:05:30 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbaLCWF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:05:29 -0500
Message-ID: <547F8925.3050308@nod.at>
Date: Wed, 03 Dec 2014 23:05:25 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>
CC: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: iio: dht11 Updates
References: <1417563176-31972-1-git-send-email-richard@nod.at> <E1Xw8sp-0001B6-Ul@stardust.g4.wien.funkfeuer.at> <547F0CFE.4010107@nod.at> <E1XwAbX-0001Ht-Jg@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1XwAbX-0001Ht-Jg@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.12.2014 um 15:08 schrieb Harald Geyer:
>> I was asking because I see the "dht11: WARNING: decoding ambiguous"
>> very often. (with and without my patches)
> 
> Yes, your patches shouldn't have any effect on this.
> "very often" in the sense of "not always"? This would be very surprising,
> because this would involve variable length clock ticks, i think.
> 
> I guess we should include timeres into the warning message.
> 
> Also I guess now is the time to think about a smarter decoder.

Another question. Your driver defines:
#define DHT11_DATA_BIT_LOW      27000
#define DHT11_DATA_BIT_HIGH     70000

If I read the manual [0] correctly these constants are T_h0/1.
Why did you use 27000 for T_h0?
Setting it to 26000 (the typical value as stated by the manual),
I get the "decoding ambiguous" warning *always*. Setting it higher
makes the message go away.

Thanks,
//richard

[0] http://meteobox.tk/files/AM2302.pdf
