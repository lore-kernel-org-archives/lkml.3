Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab3CSGBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:01:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58547 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab3CSGA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:00:58 -0400
Message-ID: <5147FF02.1070900@ti.com>
Date: Tue, 19 Mar 2013 11:30:34 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <b-cousson@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCH 1/2] driver: serial-omap: move max uart count into generic
 header file.
References: <1363604206-11264-1-git-send-email-sourav.poddar@ti.com> <87r4jcim2h.fsf@linaro.org>
In-Reply-To: <87r4jcim2h.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,
On Tuesday 19 March 2013 12:15 AM, Kevin Hilman wrote:
> Sourav Poddar<sourav.poddar@ti.com>  writes:
>
>> OMAP_MAX_HSUART_PORTS is moved to omap_serial header file.
> Why?
>
The patch is a prerequisitive for the next patch in the series, where I am
making use of the max number of uarts, omap device supports. Hence, I
am rearranging the macro from a driver file to a header file. So, it can 
be used at
multiple places.
> You started to explain it in the cover letter, but a full description
> belongs here for the permanent git history.
>
Sure, I will add the complete description for this here itself in my next
version.
> Kevin
>
>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>> Cc: Felipe Balbi<balbi@ti.com>
>> Cc: Rajendra nayak<rnayak@ti.com>
>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> ---
>>   drivers/tty/serial/omap-serial.c          |    2 --
>>   include/linux/platform_data/serial-omap.h |    1 +
>>   2 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>> index 5722eaf..4c2ba9f 100644
>> --- a/drivers/tty/serial/omap-serial.c
>> +++ b/drivers/tty/serial/omap-serial.c
>> @@ -43,8 +43,6 @@
>>   #include<linux/pinctrl/consumer.h>
>>   #include<linux/platform_data/serial-omap.h>
>>
>> -#define OMAP_MAX_HSUART_PORTS	6
>> -
>>   #define UART_BUILD_REVISION(x, y)	(((x)<<  8) | (y))
>>
>>   #define OMAP_UART_REV_42 0x0402
>> diff --git a/include/linux/platform_data/serial-omap.h b/include/linux/platform_data/serial-omap.h
>> index ff9b0aa..92c48c2 100644
>> --- a/include/linux/platform_data/serial-omap.h
>> +++ b/include/linux/platform_data/serial-omap.h
>> @@ -29,6 +29,7 @@
>>    * is used as console uart.
>>    */
>>   #define OMAP_SERIAL_NAME	"ttyO"
>> +#define OMAP_MAX_HSUART_PORTS   6
>>
>>   struct omap_uart_port_info {
>>   	bool			dma_enabled;	/* To specify DMA Mode */

