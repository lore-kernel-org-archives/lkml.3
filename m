Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3ENF4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 01:56:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59478 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3ENF4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 01:56:18 -0400
Message-ID: <5191D200.3040604@wwwdotorg.org>
Date: Mon, 13 May 2013 23:56:16 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jongsung Kim <neidhard.kim@lge.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rpi-kernel@lists.infradead.org" 
	<linux-rpi-kernel@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: PL011: add support for extended FIFO-size of PL011-r1p5
References: <007301ce375e$bcf6d6b0$36e48410$@lge.com>
In-Reply-To: <007301ce375e$bcf6d6b0$36e48410$@lge.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 03:18 AM, Jongsung Kim wrote:
> The latest r1p5-revision of the ARM PL011 UART has 32-byte FIFOs, while all
> earlier ones have 16-byte FIFOs. This patch suggests a way to set the
> FIFO-size correctly & flexibly by using a
> function(vendor_data::get_fifosize) rather than using the
> vendor_data::fifosize variable. The function takes the UARTPeriphID, and
> returns the correct size.

This change (now part of 3.10-rc1) breaks the serial port on the BCM2835
ARM SoC (part of the Raspberry Pi). Sorry for not noticing this earlier;
a combination of my vacation and laziness I guess.

For reference, the AMBA periphid of the UART device there is 0x00341011.
The nibble "3" is the revision being tested in:

> +static unsigned int get_fifosize_arm(unsigned int periphid)
> +{
> +	unsigned int rev = (periphid >> 20) & 0xf;
> +	return rev < 3 ? 16 : 32;
> +}

Should that be <= not <, or is there just something more wrong in the
patch or bcm2835 HW? I wonder how r1p5 maps to 3 in the test above.
