Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3JWDKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 23:10:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50585 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3JWDKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 23:10:10 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52673E08.4070707@roeck-us.net>
Date: Tue, 22 Oct 2013 20:10:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>,
        linux-kernel@vger.kernel.org
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Michael Buesch <m@bues.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Driver Design Question
References: <20131022070256.GA5527@jtlinux>
In-Reply-To: <20131022070256.GA5527@jtlinux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 12:02 AM, Johannes Thumshirn wrote:
> Hi List,
>
> I have a design question concerning a device driver. The device in question is
> somewhere in between drivers/mfd/timberdale and drivers/ssb. It is mapped
> connected via PCI and on PCI Bar 0 there is a table describing which
> "sub-devices" are contained in the FPGA as well as where their Memory and IRQ
> resources are.
>
> Unlike the timberdale driver, there is no static configuration of the FPGA's
> sub-devices, but their number and kind is variable. But luckily we have unique
> device-ids for every sub-device, so it is possible to do a PCI/USB like
> enumeration.
>
> In my understanding the MFD API, which timberdale uses, isn't tailored to this
> Plug'n'Play like behavior. Whereas the I think (virtual) bus concept used by

Not sure if that is true. There is no requirement to declare mfd cells
statically. As long as the devices don't change after mfd probe, an mfd based
solution would at least be implementable.

However, adding support for new sub-devices might be an issue, as you would
have to update the mfd driver to add support for each new device (to create its
mfd cell and platform data), in addition to writing the actual driver.

> SSB is much more suited for this kind of devices. But would it be wise to add a
> bus only suited to devices manufactured by one vendor, when there is already a
> API for such kinds of multi function devices?
>
Assuming you refer to mfd, isn't that a contradiction ? You just stated that mfd
doesn't exactly meet your requirements. There is also an API for adding a new bus,
and it is used quite widely.

Question for me would be if the additional overhead for adding a bus outweighs its
benefits.

> Long story short, which would be the preferred way to implement such a driver? At
> the point I currently reached I could go in both directions.
>
> I'd appreciate any advice I can get on this topic.
>

I'm adding Greg KH to the thread. Maybe he has some useful advice as the driver core
maintainer. I have struggled with the question if to add a bus myself, so maybe I can
get something useful out of it ;).

Thanks,
Guenter

> Thanks in advance,
>
>         Johannes
>
> P.S.: MFD and SSB maintainers are on CC as I'd really like to hear their opinion
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
>

