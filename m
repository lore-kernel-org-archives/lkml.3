Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaGKDLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 23:11:55 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:54386 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaGKDLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 23:11:54 -0400
Message-ID: <53BF55FE.9090500@linaro.org>
Date: Thu, 10 Jul 2014 22:11:58 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: heikki.krogerus@linux.intel.com, david.daney@cavium.com,
        loic.poulain@intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] serial: 8250_dw: support high baudrates if possible
References: <1404227734-14180-1-git-send-email-elder@linaro.org> <20140710231342.GA9557@kroah.com>
In-Reply-To: <20140710231342.GA9557@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 06:13 PM, Greg KH wrote:
> On Tue, Jul 01, 2014 at 10:15:34AM -0500, Alex Elder wrote:
>> Currently the Synopsys DesignWare 8250 driver assumes its UART clock
>> runs at a fixed rate.  If a "real" clock was set up using the common
>> clock framework, and that clock's rate is adjustable, it may be
>> possible to support a wider range of baud rates by changing the
>> UART clock rate.
>>
>> This is done by setting up a uart_port->set_termios method that
>> requests a clock rate change if a different rate might make it
>> more likely to achieve a specified baud.  A new function
>> dw8250_adjustable_clk() determines whether such clock rate
>> adjustment is an option.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>> v2: Limit clock changing to specific compatible devices.
>>
>>  drivers/tty/serial/8250/8250_dw.c | 57 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 57 insertions(+)
> 
> This no longer applies due to other changes in this driver.  Can you
> please refresh it against my tty-next branch of the tty.git tree and
> resend?

Interesting.  Heikki seems to have generalized
byt_set_termios() into dw8250_set_termios(), such
that it's almost the same as what I did.

I think I can just reuse it and simplify my patch
considerably.  But I'll do that in the morning...

					-Alex


> thanks,
> 
> greg k-h
> 

