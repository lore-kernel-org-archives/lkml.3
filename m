Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaF1UPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:15:53 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:41886 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaF1UPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:15:52 -0400
Message-ID: <53AF227C.3000102@linaro.org>
Date: Sat, 28 Jun 2014 15:15:56 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        david.daney@cavium.com, loic.poulain@intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_dw: support high baudrates if possible
References: <1403889920-1127-1-git-send-email-elder@linaro.org> <20140628163608.0c5536a9@alan.etchedpixels.co.uk>
In-Reply-To: <20140628163608.0c5536a9@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 10:36 AM, One Thousand Gnomes wrote:
> On Fri, 27 Jun 2014 12:25:20 -0500
>> +		rate = 16 * max(115200U, (unsigned int)baud);
>> +
> 
> This assumes an arbitarily configurable clock, which is not I think the
> usual case. 

If the clock's rate can't change, this will return an error,
and the recorded rate (p->uartclk) will not be changed.

This should only matter when attempting to set a baud rate higher
than 115200.  It *is* possible that some particular high rate
will realize a better signal rate than whatever results from
requesting 16 times the baud (or even 16 * 115200).

I could make this work *only* for my particular part(s) by
relying on a different device tree compatible string and
setting a flag.  It would be nice if other implementations
could benefit from this though.

					-Alex

>> +		/*
>> +		 * Request a different clock rate if necessary, and
>> +		 * record it if successful.
>> +		 */
>> +		if (rate != p->uartclk) {
>> +			BUG_ON(!data->clk);
>> +			if (!clk_set_rate(data->clk, (unsigned long)rate))
>> +				p->uartclk = rate;
>> +		}
> 
> 

