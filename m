Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbbAENVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:21:19 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:35477 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbbAENVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:21:17 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "jslaby@suse.cz" <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/3] serial: 8250_early: prepare for dynamic BASE_BAUD
Thread-Topic: [PATCH v2 2/3] serial: 8250_early: prepare for dynamic
 BASE_BAUD
Thread-Index: AQHQKNsX6WbkZQB8V0WNqr8z00JbjA==
Date: Mon, 5 Jan 2015 13:21:13 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BC9CCD@IN01WEMBXA.internal.synopsys.com>
References: <1420457437-17636-1-git-send-email-vgupta@synopsys.com>
 <1420457437-17636-3-git-send-email-vgupta@synopsys.com>
 <54AA8AFC.9020706@hurleysoftware.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Monday 05 January 2015 06:31 PM, Peter Hurley wrote:
> Hi Vineet,
>
> On 01/05/2015 06:30 AM, Vineet Gupta wrote:
>> -	port->uartclk = BASE_BAUD * 16;
>> +	port->uartclk = earlycon_base_baud(options) * 16;
> I don't understand why BASE_BAUD can't be defined by arc as arc_earlycon_base_baud().
> Why is the weak binding necessary?

Indeed weak semantics are not really needed - even now we have what u r suggesting
- the missing part was existing conditional definition which will simply go away
if I implement the fdt parsing in that singly defined function. Thx for the tip :-)

In that case this requires no change to driver and I can fixup the platform -
perhaps ur Ack on next version will be nice.
Also what do u think of the early IER optimization ?

>
> I'm pushing back on this because port initialization (and especially 8250)
> is already a ridiculous spiderweb.

I totally agree.

Thx,
-Vineet

>
> Regards,
> Peter Hurley
>
>>  	options = strchr(options, ',');
>>  	if (options) {
>> @@ -156,7 +165,7 @@ int __init of_setup_earlycon(unsigned long addr,
>>  
>>  	port->iotype = UPIO_MEM;
>>  	port->mapbase = addr;
>> -	port->uartclk = BASE_BAUD * 16;
>> +	port->uartclk = earlycon_base_baud(NULL) * 16;
>>  	port->membase = earlycon_map(addr, SZ_4K);
>>  
>>  	early_console_dev.con->data = &early_console_dev;
>>
>

