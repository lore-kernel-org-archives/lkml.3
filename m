Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaIAHrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:47:06 -0400
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:52147 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaIAHrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:47:05 -0400
Message-ID: <5404246E.4090908@de.bosch.com>
Date: Mon, 1 Sep 2014 09:46:54 +0200
From: Dirk Behme <dirk.behme@de.bosch.com>
Organization: Robert Bosch Car Multimedia GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>,
        <linux-kernel@vger.kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com> <20140829190129.GZ29327@sirena.org.uk>
In-Reply-To: <20140829190129.GZ29327@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.211.33]
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.08.2014 21:01, Mark Brown wrote:
> On Fri, Aug 29, 2014 at 10:19:16PM +0400, Dmitry Eremin-Solenikov wrote:
>> From: Dirk Behme <dirk.behme@de.bosch.com>
>>
>> With GPIO #0, this if statement will always fail. Remove this, the
>> check for gpio_is_valid() is sufficent here.
>
> No, read the archives


Could you kindly give us a pointer to the relevant thread in the archive?


> this will break boards using zero as default.
> Any current boards should be using DT and so shouldn't be using fixed
> GPIO numbers in the first place which will mean they'll not end up
> getting zero as a valid GPIO.


Hmm? What's wrong with a DT entry

<&gpio1 0 0>;

for ena_gpio resulting in zero as a valid GPIO?


> If you are using zero as a GPIO for some
> reason provide a way to specify that the GPIO is a real GPIO and not
> just the default value for the struct.


Do you want to say that GPIO #0 (<&gpio1 0 0>;) isn't a valid GPIO for 
config->ena_gpio?


I wonder how this fits to

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/gpio/gpio-legacy.txt

"GPIOs are identified by unsigned integers in the range 0..MAX_INT"

"If you want to initialize a structure with an invalid GPIO number, use
some negative number (perhaps "-EINVAL");"

then?


Best regards

Dirk
