Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbaDHECj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 00:02:39 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59085 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaDHECh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 00:02:37 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <534374D5.3020601@roeck-us.net>
Date: Mon, 07 Apr 2014 21:02:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Peter Tyser <ptyser@xes-inc.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Adding interrupt support to gpio-ich driver (possibly via SCI)
References: <533EDD0E.8010304@roeck-us.net> <20140408024851.GA3594@srcf.ucam.org> <53436B1C.8010102@roeck-us.net> <20140408033114.GA28159@srcf.ucam.org>
In-Reply-To: <20140408033114.GA28159@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 08:31 PM, Matthew Garrett wrote:
> On Mon, Apr 07, 2014 at 08:21:00PM -0700, Guenter Roeck wrote:
>> On 04/07/2014 07:48 PM, Matthew Garrett wrote:
>>> You shouldn't need to install an SCI handler - the way the hardware will
>>> generate an SCI is to raise a GPE. If you know which GPE the device
>>> raises (my recollection is that for most Intel chipsets it's GPIO number
>>> + 0x10) then you can just call acpi_install_gpe_handler(). The problem
>>
>> Sounds good. Do you by any chance have a pointer to some documentation
>> explaining this in some more detail ?
>
> The SCI is just IRQ 9 - it tells the OS that there's a firmware event,
> but in itself doesn't say what that event was. This is handled by the
> platform setting bits in the GPE*_STS registers. The ACPI code reads
> that and then dispatches the event to the appropriate handler. This will
> typically be some ACPI code (declared by _Lxx and _Exx methods in the
> ACPI tables - xx corresponds to the GPE number, L and E whether it's
> level or edge triggered), but in some cases you want to install a
> hardcoded event handler.
>
> I've only got the 5-series docs to hand, and I can't remember whether
> that's Panther Point, but you want to look at the definition of GPE0_STS
> to figure out which hardware events cause which GPEs. GPEs 16 to 31
> appear to correspond to GPIO 0 to 15, which is easy enough to handle.
>
Panther Point is Series 7 if I understand correctly, but the GPE0_STS
definition is the same.

That should get me started - thanks again!

Guenter

>>> is that the firmware may well already be using some of those GPIOs, and
>>> there's no easy way to tell. Checking the interrupt configuration isn't
>>> sufficient, since some of them may just be used as outputs.
>>>
>> The gpio-ich driver already has some magic to detect that condition - I
>> noticed that I can not request all GPIO pins on all hardware. Either case,
>> the gpio pins I am interested in are well defined on the hardware I am
>> dealing with, so I can be sure I won't step on some unexpected use.
>
> Ok. As long as you don't reprogram anything by default, I think this
> should be fine.
>

