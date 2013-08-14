Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab3HNJGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:06:37 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:39018
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759501Ab3HNJGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:06:32 -0400
Message-ID: <520B4897.30803@newflow.co.uk>
Date: Wed, 14 Aug 2013 10:06:31 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: andy@aeruder.net
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] OMAP: allow GPIO pin to enable/disable external UART driver
 chip.
References: <520646F0.9010801@newflow.co.uk> <20130813201254.GA14631@gmail.com>
In-Reply-To: <20130813201254.GA14631@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/13 21:12, Andrew Ruder wrote:
> Sorry for the late reply, I've been thinking about this for some time
> and was sad to see it didn't really evoke any sort of discussion :(.
> 
> On Sat, Aug 10, 2013 at 02:58:08PM +0100, Mark Jackson wrote:
>> When a UART transmitter is connected to (eg) a RS485 driver, it is
>> necessary to turn the driver on/off as quickly as possible.  This is
>> best achieved in the serial driver itself (rather than in userspace
>> where the latency can be quite large).
>>
>> This patch allows the GPIO pin to be defined (via DT) that controls
>> the enabling of the driver at the start of a message, and disables
>> the driver when the message has been completed.
>>
>> Still to do:-
>> Allow userspace to turn this feature on/off
>> Do the same for the receiver (useful for 2 wire RS485)
> 
> I've been wondering about this as well but I have a slightly different
> situation.  On my board the RTS line controls the RS485 transmit/receive
> direction.
> 
> I don't know if you've found the Documentation/serial/serial-rs485.txt
> file but it describes, at the very least, a standard API For controlling
> several parameters related to RS485 including configurable delay between
> rts->start of data/end of data->rts.  Unfortunately it seems like only
> one driver really implements the full API (Atmel AT91) and I guess it
> needs to be bolted onto each serial driver individually (although it
> seems like a fairly general concept that could be handled at another
> level).
> 
> That being said, maybe this patch would better be rethought as a way to
> specify a GPIO for the RTS line (I don't know enough about OMAP and
> whether or not it already provides for hardware flow control in its
> builtin UARTs and you just aren't using it for RS485 flow control?) and
> then in a separate patch implement this already documented user->kernel
> API?

I've actually submitted a newer version that does support the documented
API.  See http://permalink.gmane.org/gmane.linux.ports.arm.omap/102765

Does this address some of your questions ?

