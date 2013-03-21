Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab3CUIhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:37:24 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:50607 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932461Ab3CUIhV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:37:21 -0400
From: Philippe LANGLAIS <philippe.langlais@st.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Hans-Peter Oeri <hp@oeri.ch>,
        "heikki.krogerus@linux.intel.com" <heikki.krogerus@linux.intel.com>
Date: Thu, 21 Mar 2013 09:36:58 +0100
Subject: Re: [PATCH] tty: serial: 8250: remove U6715 16550A auto-detection
Thread-Topic: [PATCH] tty: serial: 8250: remove U6715 16550A auto-detection
Thread-Index: Ac4mD0Bt5J+f/cqmR2uW78XQrhT4tw==
Message-ID: <514AC6AA.6050102@st.com>
References: <1363722609-20021-1-git-send-email-philippe.langlais@st.com>
 <20130320172125.GB28605@kroah.com>
In-Reply-To: <20130320172125.GB28605@kroah.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/20/2013 06:21 PM, Greg Kroah-Hartman wrote:
> On Tue, Mar 19, 2013 at 08:50:09PM +0100, Philippe Langlais wrote:
>> The auto-detection based on 64 bytes fifo size causes troubles
>> for the identification of the MultiTechZPX Modems (pci 11c1:0480).
>> They loose the ability to do hardware flow control
>> (specifically CTS is never set).
>>
>> Signed-off-by: Philippe Langlais <philippe.langlais@st.com>
>> ---
>>   drivers/tty/serial/8250/8250.c |    9 ---------
>>   1 file changed, 9 deletions(-)
>>
>> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
>> index cf6a538..3255014 100644
>> --- a/drivers/tty/serial/8250/8250.c
>> +++ b/drivers/tty/serial/8250/8250.c
>> @@ -1026,15 +1026,6 @@ static void autoconfig_16550a(struct uart_8250_port *up)
>>   
>>   		return;
>>   	}
>> -
>> -	/*
>> -	 * We distinguish between 16550A and U6 16550A by counting
>> -	 * how many bytes are in the FIFO.
>> -	 */
>> -	if (up->port.type == PORT_16550A && size_fifo(up) == 64) {
>> -		up->port.type = PORT_U6_16550A;
>> -		up->capabilities |= UART_CAP_AFE;
>> -	}
> So you just broke this functionality for all of the other devices it
> does work properly for?  That's not nice, and not acceptable.
Yes, I know, but as U6715 & U6XXX kernel maintainer there is no risk to 
do that,
kernel for such platforms are not managed in mainstream, there are more 
risks
to keep these lines for other platforms.
>
> Please fix this properly.
I don't know how to distinguish MultiTechZPX Modems, so I rather to 
remove these lines.
>
> greg k-h
Philippe