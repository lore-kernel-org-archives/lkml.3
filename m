Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3DWEwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:52:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49021 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3DWEwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:52:41 -0400
Message-ID: <51761375.5040509@ti.com>
Date: Tue, 23 Apr 2013 10:22:05 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/5] driver: serial: omap: prevent runtime PM for "no_console_suspend"
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com> <1366638237-6880-3-git-send-email-sourav.poddar@ti.com> <20130422143136.GB7508@arwen.pp.htv.fi>
In-Reply-To: <20130422143136.GB7508@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,
On Monday 22 April 2013 08:01 PM, Felipe Balbi wrote:
> Hi,
>
> On Mon, Apr 22, 2013 at 07:13:54PM +0530, Sourav Poddar wrote:
>> The driver manages "no_console_suspend" by preventing runtime PM
>> during the suspend path, which forces the console UART to stay awake.
>>
>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> ---
>>   drivers/tty/serial/omap-serial.c |    5 ++++-
>>   1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>> index 08332f3..640b14e 100644
>> --- a/drivers/tty/serial/omap-serial.c
>> +++ b/drivers/tty/serial/omap-serial.c
>> @@ -1582,7 +1582,7 @@ static int serial_omap_runtime_suspend(struct device *dev)
>>   	struct uart_omap_port *up = dev_get_drvdata(dev);
>>   	struct omap_uart_port_info *pdata = dev->platform_data;
>>
>> -	if (!up)
>> +	if (!up || (!console_suspend_enabled&&  uart_console(&up->port)))
>>   		return -EINVAL;
> -EBUSY would be a better value for uart_console case, so this check
> should be splitted accordingly. Likewise on second hunk.
>
Ok. Will change in the next version.
