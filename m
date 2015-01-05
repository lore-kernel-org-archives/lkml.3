Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbbAENeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:34:17 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:63140 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbbAENeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:34:13 -0500
Message-ID: <54AA92C7.8070209@hurleysoftware.com>
Date: Mon, 05 Jan 2015 08:33:59 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "jslaby@suse.cz" <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/3] serial: 8250_early: prepare for dynamic BASE_BAUD
References: <1420457437-17636-1-git-send-email-vgupta@synopsys.com> <1420457437-17636-3-git-send-email-vgupta@synopsys.com> <54AA8AFC.9020706@hurleysoftware.com> <C2D7FE5348E1B147BCA15975FBA2307565BC9CCD@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307565BC9CCD@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 08:21 AM, Vineet Gupta wrote:
> Hi Peter,
> 
> On Monday 05 January 2015 06:31 PM, Peter Hurley wrote:
>> Hi Vineet,
>>
>> On 01/05/2015 06:30 AM, Vineet Gupta wrote:
>>> -	port->uartclk = BASE_BAUD * 16;
>>> +	port->uartclk = earlycon_base_baud(options) * 16;
>> I don't understand why BASE_BAUD can't be defined by arc as arc_earlycon_base_baud().
>> Why is the weak binding necessary?
> 
> Indeed weak semantics are not really needed - even now we have what u r suggesting
> - the missing part was existing conditional definition which will simply go away
> if I implement the fdt parsing in that singly defined function. Thx for the tip :-)
> 
> In that case this requires no change to driver and I can fixup the platform -
> perhaps ur Ack on next version will be nice.

Will do.

> Also what do u think of the early IER optimization ?

Seems ok except the commit changelog is wrong: IER is disabled twice per _line_.
How did you profile it? It's ok if the answer is "seemed faster"; I'm just
curious.

Regards,
Peter Hurley

>> I'm pushing back on this because port initialization (and especially 8250)
>> is already a ridiculous spiderweb.
> 
> I totally agree.
> 
> Thx,
> -Vineet
> 
>>
>> Regards,
>> Peter Hurley
>>
>>>  	options = strchr(options, ',');
>>>  	if (options) {
>>> @@ -156,7 +165,7 @@ int __init of_setup_earlycon(unsigned long addr,
>>>  
>>>  	port->iotype = UPIO_MEM;
>>>  	port->mapbase = addr;
>>> -	port->uartclk = BASE_BAUD * 16;
>>> +	port->uartclk = earlycon_base_baud(NULL) * 16;
>>>  	port->membase = earlycon_map(addr, SZ_4K);
>>>  
>>>  	early_console_dev.con->data = &early_console_dev;
>>>
>>
> 

