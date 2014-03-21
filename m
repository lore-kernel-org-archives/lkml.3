Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbaCUIy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:54:57 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:60883 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488AbaCUIyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:54:54 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <532BFE5C.2010401@ladisch.de>
Date: Fri, 21 Mar 2014 09:54:52 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jaime T <enopatch@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Testing 1 hard disk in 3 different usb enclosures: kernel reports
 3 different "numbers of sectors"
References: <CAAbCkmKHrKHAQqjE96J=TU2ndrCrhjg6j-x2YZGUY-odWMmyBg@mail.gmail.com>
In-Reply-To: <CAAbCkmKHrKHAQqjE96J=TU2ndrCrhjg6j-x2YZGUY-odWMmyBg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaime T wrote:
> I'd like to use my 1TB Seagate hard disk on my linux box, and I've
> tested it using 3 different usb-sata enclosures.
>
> kernel: [10612.017588] usb 1-1: New USB device found, idVendor=14cd, idProduct=6116
> kernel: [10612.017602] usb 1-1: Product: USB Mass Storage Device
> kernel: [10612.017607] usb 1-1: Manufacturer: Generic
> kernel: [10730.225053] usb 1-1: New USB device found, idVendor=152d, idProduct=2509
> kernel: [10730.225067] usb 1-1: Product: Usb production
> kernel: [10730.225072] usb 1-1: Manufacturer: JMicron
> kernel: [10837.309203] usb 1-2: New USB device found, idVendor=152d, idProduct=2339
> kernel: [10837.309218] usb 1-2: Product: USB to ATA/ATAPI Bridge
> kernel: [10837.309223] usb 1-2: Manufacturer: JMicron
>
> kernel: [10613.019646] sd 25:0:0:0: [sdb] 1953525166 512-byte logical blocks: (1.00 TB/931 GiB)
> kernel: [10731.227818] sd 26:0:0:0: [sdb] 1953524995 512-byte logical blocks: (1.00 TB/931 GiB)
> kernel: [10838.311867] sd 27:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>
> So Linux (v3.10.25) is reporting 3 different sizes/numbers of sectors
> for the same single hard disk.

The kernel just reports what the device reports.

> Could this be a problem with regards to possible future data
> corruption, or is it something that I can safely ignore?

It is likely that you will not be able to access the sectors beyond
the reported limit.  It might be possible that the enclosure does not
ignore those sectors but uses them to store its own management data.


Regards,
Clemens
