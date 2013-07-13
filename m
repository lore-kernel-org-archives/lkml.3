Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab3GMWoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 18:44:46 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:34451 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3GMWoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 18:44:44 -0400
Message-ID: <51E1D858.7000809@cogentembedded.com>
Date: Sun, 14 Jul 2013 02:44:40 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        daniel@caiaq.de
Subject: Re: [PATCH] misc: add driver for Renesas R-Car Gyro-ADC/speed-pulse
 interfaces
References: <201307130351.42967.sergei.shtylyov@cogentembedded.com> <20130713005702.GA14788@kroah.com> <51E0AA24.6070203@cogentembedded.com> <20130713013000.GA22493@kroah.com>
In-Reply-To: <20130713013000.GA22493@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/13/2013 05:30 AM, Greg KH wrote:

>>>> Add the driver for Gyro-ADC/speed-pulse interfaces found in Renesas R-Car SoCs.
>>>> Though  being two separate devices, they have to be driven together because of
>>>> the shared start/stop register (located in Gyro-ADC still). At this time, only
>>>> speed-pulse interface is fully supported, the Gyro-ADC is just initialized and
>>>> started/stopped synchronously with the speed-pulse interface.  A user interface
>>>> is implemented via several sysfs files which allow to read and reset the speed-
>>>> pulse interface's registers.

>>> If you modify/create/remove sysfs files, you also have to document them
>>> in Documentation/ABI/ which is missing from this patch.

>>     I've looked there and didn't find the documentation for my closest
>> model driver, drivers/misc/ti_dac7512.c (or for many other drivers),
>> so I thought I too can do without it.

> Nope, that driver should be fixed as well, care to do so?

    Sorry, I don't. The driver has an author, which I'm CCing.

>>> Your sysfs files are also being created in a "racy" way, i.e. after
>>> userspace is told about the device, please fix that as well.

>>     Not sure I understand you. Could you elaborate?

> Please read the driver model documentation, it goes into the details of
> how to do this properly.  As does this post from me a week or so ago:
> 	http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/

    Thank you. Probably a good read for ti_dac7512 driver too.

> greg k-h

WBR, Sergei

