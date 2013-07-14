Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3GNILy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 04:11:54 -0400
Received: from smtp-out-124.synserver.de ([212.40.185.124]:1028 "EHLO
	smtp-out-124.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3GNILs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 04:11:48 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9664
Message-ID: <51E25D6A.3090106@metafoo.de>
Date: Sun, 14 Jul 2013 10:12:26 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] misc: add driver for Renesas R-Car Gyro-ADC/speed-pulse
 interfaces
References: <201307130351.42967.sergei.shtylyov@cogentembedded.com> <20130713005702.GA14788@kroah.com> <51E0AA24.6070203@cogentembedded.com> <201307130958.16533.arnd@arndb.de> <51E1D406.9090702@cogentembedded.com>
In-Reply-To: <51E1D406.9090702@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 12:26 AM, Sergei Shtylyov wrote:
> Hello.
> 
> On 07/13/2013 11:58 AM, Arnd Bergmann wrote:
> 
>>>> And are you sure you want to control this through sysfs?  There's no
>>>> other better user/kernel apis for it?
> 
>>>      I found none, besides ioctl(), as the device driven is rather
>>> unique. But I thought that sysfs is "ioctl() today", so I went with it...
> 
>> It does sound like it would fit better into IIO than just a misc driver,
>> even if it's the only hardware of its kind.
> 
>    I got somewhat familiarized myself with drivers/iio/ infrastructure and I
> have found a place only the for ADC device in which the customer currently
> has no interest.
>    The other trouble is that I'll have to backport this driver to 3.4 which
> doesn't contain the IIO infrastructure at all. :-(

It has, it's just still in staging in 3.4. But the API (except for minor
modifications) and more importantly the ABI are the same.

There is a angular velocity channel type in IIO. maybe that could be used to
report the Speed-Pulse-ADC values.

- Lars

