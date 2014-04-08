Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbaDHDVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 23:21:06 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52950 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964AbaDHDVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 23:21:04 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53436B1C.8010102@roeck-us.net>
Date: Mon, 07 Apr 2014 20:21:00 -0700
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
References: <533EDD0E.8010304@roeck-us.net> <20140408024851.GA3594@srcf.ucam.org>
In-Reply-To: <20140408024851.GA3594@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 07:48 PM, Matthew Garrett wrote:
> On Fri, Apr 04, 2014 at 09:25:50AM -0700, Guenter Roeck wrote:
>
>> Is there a clean way to use any of those to implement interrupt support
>> for this driver ? I thought about hijacking the SCI interrupt by registering
>> an interrupt handler with acpi_install_sci_handler(), but that would restrict
>> the driver to kernel only (or the acpi function would have to be exported),
>> and I have no idea if it would work or, more importantly, if it would be
>> the best approach to solve the problem, or if the result would be acceptable.
>> I can figure out the "working" part, but that would not help much if I would
>> have to carry the patch locally because it is not acceptable for upstream
>> integration.
>
> You shouldn't need to install an SCI handler - the way the hardware will
> generate an SCI is to raise a GPE. If you know which GPE the device
> raises (my recollection is that for most Intel chipsets it's GPIO number
> + 0x10) then you can just call acpi_install_gpe_handler(). The problem

Sounds good. Do you by any chance have a pointer to some documentation
explaining this in some more detail ?

> is that the firmware may well already be using some of those GPIOs, and
> there's no easy way to tell. Checking the interrupt configuration isn't
> sufficient, since some of them may just be used as outputs.
>
The gpio-ich driver already has some magic to detect that condition - I
noticed that I can not request all GPIO pins on all hardware. Either case,
the gpio pins I am interested in are well defined on the hardware I am
dealing with, so I can be sure I won't step on some unexpected use.

Thanks!

Guenter

