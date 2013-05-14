Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab3ENVDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:03:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42204 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab3ENVDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:03:18 -0400
Message-ID: <5192A692.4010700@wwwdotorg.org>
Date: Tue, 14 May 2013 15:03:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jongsung Kim <neidhard.kim@lge.com>
CC: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: PL011: add support for extended FIFO-size of PL011-r1p5
References: <007301ce375e$bcf6d6b0$36e48410$@lge.com> <5191D200.3040604@wwwdotorg.org> <01fd01ce5072$d6b9fcd0$842df670$@lge.com>
In-Reply-To: <01fd01ce5072$d6b9fcd0$842df670$@lge.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 01:15 AM, Jongsung Kim wrote:
> Stephen Warren <swarren@wwwdotorg.org> :
>> For reference, the AMBA periphid of the UART device there is 0x00341011.
>> The nibble "3" is the revision being tested in:
> 
> The UART device has periphid 0x00341011, and is compatible with the
> original PL011 prior to r1p5. Not with r1p5. It could be a possible
> way to specify the compatible periphid (such as 0x00241011) instead
> of just 0x0 when initializing the amba_device for the UART.
> 
>>> +static unsigned int get_fifosize_arm(unsigned int periphid)
>>> +{
>>> +	unsigned int rev = (periphid >> 20) & 0xf;
>>> +	return rev < 3 ? 16 : 32;
>>> +}
...
> Doesn't the BCM2835 UART have anything different from the ARM PL011?
> What about the UARTPCellID registers? They are set to 0xb105f00d with
> the ARM PL011.

Looking at BCM2835-ARM-Peripherals.pdf (i.e. the public documentation
for the BCM2835 chip), I see:

=====
The UART provides:
* Separate 16x8 transmit and 16x12 receive FIFO memory.
...
For the in-depth UART overview, please, refer to the ARM PrimeCell UART
(PL011) Revision: r1p5 Technical Reference Manual.
=====

That seems to imply that not all r1p5 PL011s actually have a depth-32
FIFO. Perhaps this is a configurable property of the IP block, not
something that all r1p5 have?

I can't check the UARTPCellID registers right now.
