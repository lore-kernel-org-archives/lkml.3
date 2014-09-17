Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaIQMB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:01:28 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38908 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754558AbaIQMB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:01:26 -0400
Message-ID: <54197804.3020302@hurleysoftware.com>
Date: Wed, 17 Sep 2014 08:01:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Frans Klaver <frans.klaver@xsens.com>
CC: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Pelykh <alexey.pelykh@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] tty: omap-serial: use threaded interrupt handler
References: <1410789610-23059-1-git-send-email-frans.klaver@xsens.com> <1410789610-23059-4-git-send-email-frans.klaver@xsens.com> <54170823.7040801@hurleysoftware.com> <5417228C.5070503@hurleysoftware.com> <20140916085037.GI28458@ci00147.xsens-tech.local>
In-Reply-To: <20140916085037.GI28458@ci00147.xsens-tech.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 04:50 AM, Frans Klaver wrote:
> On Mon, Sep 15, 2014 at 01:31:56PM -0400, Peter Hurley wrote:
>> On 09/15/2014 11:39 AM, Peter Hurley wrote:
>>> On 09/15/2014 10:00 AM, Frans Klaver wrote:
>>>> At 3.6Mbaud, with slightly over 2Mbit/s data coming in, we see 1600 uart
>>>> rx buffer overflows within 30 seconds. Threading the interrupt handling reduces
>>>> this to about 170 overflows in 10 minutes.
>>>
>>> Why is the threadirqs kernel boot option not sufficient?
>>> Or conversely, shouldn't this be selectable?
>>
> 
> I wasn't aware of the threadirqs boot option. I also wouldn't know if
> this should be selectable. What would be a reason to favor the
> non-threaded irq over the threaded irq?

Not everyone cares enough about serial to dedicate kthreads to it :)

>> Also, do you see the same performance differential when you implement this
>> in the 8250 driver (that is, on top of Sebastian's omap->8250 conversion)?
>>
> 
> I haven't gotten Sebastian's driver to work properly yet on the console.
> There was no reason for me yet to throw my omap changes on top of
> Sebastian's queue.
> 
>>> PS - To overflow the 64 byte RX FIFO at those data rates means interrupt
>>> latency in excess of 250us?
> 
> At 3686400 baud it should take about 174 us to fill a 64 byte buffer. I
> haven't done any measurements on the interrupt latency though. If you
> consider that we're sending about 1kB of data, 240 times a second, we're
> spending a lot of time reading data from the uart. I can imagine the
> system has other work to do as well.

System work should not keep irqs from being serviced. Even 174us is a long
time not to service an interrupt. Maybe console writes are keeping the isr
from running?

Regards,
Peter Hurley

