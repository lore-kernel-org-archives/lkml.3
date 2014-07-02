Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965066AbaGBAPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 20:15:25 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38157 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaGBAPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 20:15:22 -0400
Message-ID: <53B34F19.9060608@linaro.org>
Date: Tue, 01 Jul 2014 19:15:21 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        david.daney@cavium.com, loic.poulain@intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250_dw: support high baudrates if possible
References: <1403889920-1127-1-git-send-email-elder@linaro.org>	<20140628163608.0c5536a9@alan.etchedpixels.co.uk>	<53AF227C.3000102@linaro.org> <20140701230259.23f2f452@alan.etchedpixels.co.uk>
In-Reply-To: <20140701230259.23f2f452@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 05:02 PM, One Thousand Gnomes wrote:
> On Sat, 28 Jun 2014 15:15:56 -0500
> Alex Elder <elder@linaro.org> wrote:
> 
>> On 06/28/2014 10:36 AM, One Thousand Gnomes wrote:
>>> On Fri, 27 Jun 2014 12:25:20 -0500
>>>> +		rate = 16 * max(115200U, (unsigned int)baud);
>>>> +
>>>
>>> This assumes an arbitarily configurable clock, which is not I think the
>>> usual case. 
>>
>> If the clock's rate can't change, this will return an error,
>> and the recorded rate (p->uartclk) will not be changed.
> 
> Which assumes an arbitrarily configurable clock, whereas you want to find
> the correct clock and multiplier combination for the baud rate.
> 
> Most of these ports are wired to fixed clocks (which is fine) or clocks
> with limited numbers of supported frequencies (which is not).

Yes, I acknowledged that in my earlier response.  But over
the weekend I decided to abandon hope that I'd be able to
verify there are no problems for affected machines, and
re-formulated my patch.
    https://lkml.org/lkml/2014/7/1/323

> Your patch is an improvement but doesn't really fix the overall problem.
> If we have enough devices with variable clocks for it to be useful then
> fine - but can we merge it with a big FIXME note so that whoever comes
> along wondering why their clock doesn't work or behaves very oddly can
> figure it out and fix that case ?

What I've done now is define a dw8250_adjustable_clk() predicate
that indicates the UART baud can be adjusted by changing the
clock rate.  Anyone who wants to activate this functionality
can just modify that function to recognize their device.

							-Alex

> Alan
> 

