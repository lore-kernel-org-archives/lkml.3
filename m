Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902AbaKNA77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:59:59 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59481 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933409AbaKNA74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:59:56 -0500
Message-ID: <54655409.6030604@codeaurora.org>
Date: Thu, 13 Nov 2014 16:59:53 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: Kevin Hilman <khilman@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Tyler Baker <tyler.baker@linaro.org>
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org> <CAMAWPa_f1K1qUG_UTmM0w8Sz8wed7+CQkK9tc8t1W=CTJvdjyw@mail.gmail.com> <5461150B.2010907@codeaurora.org> <54616CB3.5000405@gmail.com> <54616F74.5010408@codeaurora.org> <54618077.9000108@gmail.com> <5463A381.9060305@gmail.com> <5465072F.6040509@codeaurora.org> <546550FF.2080409@gmail.com>
In-Reply-To: <546550FF.2080409@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 04:46 PM, Frank Rowand wrote:
> On 11/13/2014 11:31 AM, Stephen Boyd wrote:
>> Sorry, I'm sort of lost. If there are serial aliases in the dts file,
>> then we should alias all of the serial ports. If there aren't aliases
>> then we're backwards compatible with the dts we have now and we'll do
>> dynamic generation. Putting code into the driver to validate that
>> this is true is not the job of the driver. If anything, it should
>> validated when the dts file is created. If one day we screw up and
>> have a dts file with such a bad configuration we'll have to work
>> around it, but until that day comes I'd rather not think about it. 
> Maybe I did not understand when you said "Perhaps we should use an ida".
> That sentence led me to think the driver should check for misconfiguration.
> The case I was trying to handle was if there was at least one serialN
> alias and at least one UART without an alias.  For example, if there
> are three UARTs (serial_a, serial_b, serial_c, probed in that order)
> and one alias (serial0 = &serial_c;) then the result would be:
>
>    serial_a  line 0 (from msm_uart_next_id)
>    serial_b  line 1 (from msm_uart_next_id)
>    serial_c  line 0 (from the alias)
>
>    Two UARTs probed with line == 0.  This is an error.
>
> Most of the serial drivers don't check for this type of bad configuration.
> Some drivers keep a bit map of which lines have been used.  I'm not sure
> what they do in case of a conflict (I did not read to that level of detail).
>
> I thought you were suggesting the driver check for the bad configuration,
> so I was proposing a somewhat simple way of forcing a boot error for the
> bad configuration.
>
> Since you are not suggesting the driver check for the bad configuration,
> you can ignore my proposal.  I agree that it is ok for the driver to
> expect the board dts to be correct.  The problem should be detected by
> the dts author on first boot as part of normal bring up testing, and
> then corrected.
>

Ah ok. I was just saying we could use an ida instead of an atomic
increment so that this driver works properly with driver
binding/unbinding, otherwise the line number keeps increasing and
quickly goes beyond the static array of ports (which I still don't
understand why we have at all btw).

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

