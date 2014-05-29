Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbaE2Ppx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:45:53 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:60548 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520AbaE2Ppv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:45:51 -0400
Message-ID: <5387562B.8070809@dev.rtsoft.ru>
Date: Thu, 29 May 2014 19:45:47 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
References: <Pine.LNX.4.44L0.1405291139000.1285-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1405291139000.1285-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

29.05.2014 19:44, Alan Stern пишет:
> On Thu, 29 May 2014, Nikita Yushchenko wrote:
> 
>> 29.05.2014 18:42, One Thousand Gnomes пишет:
>>>> I don't know how linux usb subsystem should behave against such
>>>> "half-existing" hardware. Perhaps hanging is not the best idea...
>>>> but maybe it should be fixed elsewhere, e.g. by masking non-wired
>>>> devices in platform PCI setup. Perhaps controlled by some device-tree
>>>> key.
>>>
>>> Does it have a unique svid/sdid set for the platform - if so you could
>>> just blacklist that combination of vid/did/svid/sdid.
>>
>> Unfortunately vid/did/svid/sdid come from ULI 1553 southbridge chip,
>> that is used by other hardware as well. AFAIK it is still being
>> manufactured, and could appear in PCs or laptops.
> 
>>> It would help to print the value of fminterval.
>>> And here to print the value obtained by the readl().
>>
>> I've checked these... all values read as 0xffffffff - which does not
>> look correct
> 
> You could have the platform setup code read one of those hardware
> registers, such as FMINTERVAL.  If it obtains 0xffffffff, don't
> register the OHCI controller as a platform device.

It is not a platform_device, it is PCI device that is found via bus scan.

