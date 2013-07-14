Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3GNT5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:57:30 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:33562 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab3GNT52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:57:28 -0400
Message-ID: <51E302A4.6080801@cogentembedded.com>
Date: Sun, 14 Jul 2013 23:57:24 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] misc: add driver for Renesas R-Car Gyro-ADC/speed-pulse
 interfaces
References: <201307130351.42967.sergei.shtylyov@cogentembedded.com> <20130713005702.GA14788@kroah.com> <51E0AA24.6070203@cogentembedded.com> <201307130958.16533.arnd@arndb.de> <51E1D406.9090702@cogentembedded.com> <51E25D6A.3090106@metafoo.de>
In-Reply-To: <51E25D6A.3090106@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/14/2013 12:12 PM, Lars-Peter Clausen wrote:

>>>>> And are you sure you want to control this through sysfs?  There's no
>>>>> other better user/kernel apis for it?

>>>>       I found none, besides ioctl(), as the device driven is rather
>>>> unique. But I thought that sysfs is "ioctl() today", so I went with it...

>>> It does sound like it would fit better into IIO than just a misc driver,
>>> even if it's the only hardware of its kind.

>>     I got somewhat familiarized myself with drivers/iio/ infrastructure and I
>> have found a place only the for ADC device in which the customer currently
>> has no interest.
>>     The other trouble is that I'll have to backport this driver to 3.4 which
>> doesn't contain the IIO infrastructure at all. :-(

> It has, it's just still in staging in 3.4. But the API (except for minor
> modifications) and more importantly the ABI are the same.

    Thank you for the useful information. I wouldn't probably have 
figured it out to search there.

> There is a angular velocity channel type in IIO. maybe that could be used to
> report the Speed-Pulse-ADC values.

    You probably misunderstood from my terse description. Multichannel 
ADC interface is separate from the speed-pulse interface which has on 
its single input digital PWM signal of varying frequency. Speed pulse 
i/f measures pulse count and period. I've found no adequate channel type 
in IIO infrastructure so far. I'll mail the IIO maintainers with a 
request for help probably...

> - Lars

WBR, Sergei

