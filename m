Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3DJF1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:27:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43748 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab3DJF13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:27:29 -0400
Message-ID: <5164F82D.3090501@ti.com>
Date: Wed, 10 Apr 2013 10:57:09 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>, <khilman@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv3] driver: serial: prevent UART console idle on suspend
 while using "no_console_suspend"
References: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com> <20130408171432.GY30923@n2100.arm.linux.org.uk>
In-Reply-To: <20130408171432.GY30923@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,
On Monday 08 April 2013 10:44 PM, Russell King - ARM Linux wrote:
> On Fri, Apr 05, 2013 at 06:45:33PM +0530, Sourav Poddar wrote:
>> With dt boot, uart wakeup after suspend is non functional while using
>> "no_console_suspend" in the bootargs. With "no_console_suspend" used, we
>> should prevent the runtime suspend of the uart port which is getting used
>> as an console.
>>
>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>> Cc: Felipe Balbi<balbi@ti.com>
>> Cc: Rajendra nayak<rnayak@ti.com>
>> Tested on omap5430evm, omap4430sdp.
>>
>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> ---
>> v2->v3
>> Based on Kevin Hilman and Santosh Shilimkar comments, modified
>> serial core/driver layer to bypass runtime suspend
>> for console uart while using "no_console_suspend".
>>
>> This patch is based on Santosh Shilimkar serial patch[1]
> Rather than introducing this "port_is_console" thing, please move
> uart_console() into the serial_core.h header file, making it an inline
> function, and use that in omap-serial.c.
>
> Remember to fix drivers/tty/serial/mpc52xx_uart.c as well for that change.
Thanks for the pointer. Will take care of your suggestions
in the next version.

~Sourav
