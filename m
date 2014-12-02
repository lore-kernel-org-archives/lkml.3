Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbaLBUjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:39:40 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbaLBUjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:39:39 -0500
Message-ID: <547E2386.9030901@nod.at>
Date: Tue, 02 Dec 2014 21:39:34 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Harald Geyer <harald@ccbib.org>
CC: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iio: dht11: IRQ fixes
References: <1417465651-16036-1-git-send-email-richard@nod.at> <1417465651-16036-2-git-send-email-richard@nod.at> <E1XvkYl-00013g-VO@stardust.g4.wien.funkfeuer.at> <547D9A6F.9010801@nod.at> <E1Xvn2b-0001CH-PM@stardust.g4.wien.funkfeuer.at> <547E0109.8000106@nod.at> <E1XvtRn-000158-1J@stardust.g4.wien.funkfeuer.at>
In-Reply-To: <E1XvtRn-000158-1J@stardust.g4.wien.funkfeuer.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald,

Am 02.12.2014 um 20:49 schrieb Harald Geyer:
>> Yeah, if the sensor starts transmitting data before we've setup
>> the IRQ we'll lose edges.
> 
> Yes, but you missunderstood me. That's not the point.
> 
> The point is that now the edges that the driver generates while
> the gpio is configured as output are part of the preamble of the
> data transmission. I think with your patch applied this is no longer
> the case (we don't get interrupts for these edges anymore). So the
> decoding needs to be changed to work with a shorter preamble.

Hmm, I get always 84 edges.
This value makes sense to me, 40 bits (80 edges) plus 4 preamble edges.

>> But AFAICT the DHT is much slower than we are with setting up the IRQ.
>> The DHT is a rather stupid device so we cannot use proper interrupting.
>> But I can think of adding also polling support to the driver.
>> Such that one can select whether she wants to use IRQ or polling...
> 
> I don't like the idea of a polling driver. Also I don't think it will
> be necessary.

Of course polling is ugly, if IRQ works let's keep it as is. :)

>>> Since it seems you have some interesst in working on these parts,
>>> let me mention an unrelated issue: The DHT22 stops sending data
>>> after a random time (think of days here) which AFAIK only can be
>>> worked around by power-cycling the sensor. I mean to add something
>>> for this to the driver but couln't make up my mind about what the
>>> proper ABI for this would be, so right now I'm using some userspace
>>> hack for this. (The issue was already discussed on the linux-iio
>>> mailing list a few month ago, if you want to look into this.
>>> Anyway: You have been warned ... ;)  
>>
>> Oh, that's a very valuable information!
>> Currently I'm evaluating some sensors for a private project.
>> You can recommend a better temp/humidity sensor?
> 
> No really. When I noticed these cheap little parts are actually
> *cheap* parts, I looked which sensors are already supported by
> hwmon, but none appealed to me, so I decided to try and work
> around this in software as far as possible. It's not hard to do, just
> hard to do right. ;)
> 
> The best I can recommend you is to have a look at the list of
> humidity sensors supported by hwmon yourself.

Ok!

Thanks,
//richard
