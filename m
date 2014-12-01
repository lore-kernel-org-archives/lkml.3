Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaLAOSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:18:46 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbaLAOSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:18:44 -0500
Message-ID: <547C78BF.3030709@nod.at>
Date: Mon, 01 Dec 2014 15:18:39 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Harald Geyer <harald@ccbib.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iio: dht11 broken
References: <547B4464.9090300@nod.at>	<E1XvOXs-00014Z-6F@stardust.g4.wien.funkfeuer.at>	<547C4A26.3070108@nod.at> <CACRpkdbSUJMF_1_8aZ+ECHAT+ztsa4jXuSFo_+V9gr1MzsNCcg@mail.gmail.com>
In-Reply-To: <CACRpkdbSUJMF_1_8aZ+ECHAT+ztsa4jXuSFo_+V9gr1MzsNCcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.12.2014 um 15:08 schrieb Linus Walleij:
> On Mon, Dec 1, 2014 at 11:59 AM, Richard Weinberger <richard@nod.at> wrote:
>> Am 01.12.2014 um 11:49 schrieb Harald Geyer:
> 
>>> Any input from gpiolib people about what the proper fix would be in
>>> their opinion, of course is appreciated. I don't think the dht11 driver
>>> is doing anything unreasonable per se, so maybe they can clarify how
>>> the API is intended to be used?
>>
>> Your driver sets up a GPIO as IRQ and then you switch the mode to output
>> to enable the DHT sensor.
>> This is not an API issue, it is an design issue.
>> I'm not a hardware expert but AFAIK setting an IRQ pin into output mode can
>> lead to undefined behavior.
> 
> Well that check is there exactly to prevent madness like this.
> 
> IRQs on pins set to output *does* *not* *make* *sense*.
> 
> Remove the IRQ before setting the pin to output and vice
> versa and everyone will be happier.

Thanks for the confirmation.
I'll cook up a patch.

Thanks,
//richard
