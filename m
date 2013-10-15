Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab3JOJK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:10:57 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:28095 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3JOJKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:10:54 -0400
Message-ID: <525D069B.6000908@atmel.com>
Date: Tue, 15 Oct 2013 11:10:51 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Wu <josh.wu@atmel.com>, Bo Shen <voice.shen@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-serial@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tty/serial: at91: fix uart/usart selection for older
 products
References: <a58fe8bc7fdd128a2f9cf60785f81ebde4c0c247.1381394411.git.nicolas.ferre@atmel.com> <20131014135809.GF11420@ns203013.ovh.net>
In-Reply-To: <20131014135809.GF11420@ns203013.ovh.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/2013 15:58, Jean-Christophe PLAGNIOL-VILLARD :
> On 10:43 Thu 10 Oct     , Nicolas Ferre wrote:
>> Since commit 055560b04a8cd063aea916fd083b7aec02c2adb8 (serial: at91:
>> distinguish usart and uart) the older products which do not have a
>> name field in their register map are unable to use their serial output.
>> As the main console output is usually the serial interface (aka DBGU) it
>> is pretty unfortunate.
>> So, instead of failing during probe() we just silently configure the serial
>> peripheral as an uart. It allows us to use these serial outputs.
>> The proper solution is proposed in another patch.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>   drivers/tty/serial/atmel_serial.c | 9 ++-------
>>   1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
>> index d067285..6b0f75e 100644
>> --- a/drivers/tty/serial/atmel_serial.c
>> +++ b/drivers/tty/serial/atmel_serial.c
>> @@ -1499,7 +1499,7 @@ static void atmel_set_ops(struct uart_port *port)
>>   /*
>>    * Get ip name usart or uart
>>    */
>> -static int atmel_get_ip_name(struct uart_port *port)
>> +static void atmel_get_ip_name(struct uart_port *port)
>>   {
>>   	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>>   	int name = UART_GET_IP_NAME(port);
>> @@ -1518,10 +1518,7 @@ static int atmel_get_ip_name(struct uart_port *port)
>>   		atmel_port->is_usart = false;
>>   	} else {
> 		a dev_warn here maybe
>
> usefull to known when we will have a new ip name and not yet wupported

No, not here: next patch is oveloading this if/else directive.

>>   		dev_err(port->dev, "Not supported ip name, set to uart\n");
>> -		return -EINVAL;
>>   	}
>> -
>> -	return 0;
>>   }
>>
>>   /*
>> @@ -2405,9 +2402,7 @@ static int atmel_serial_probe(struct platform_device *pdev)
>>   	/*
>>   	 * Get port name of usart or uart
>>   	 */
>> -	ret = atmel_get_ip_name(&port->uart);
>> -	if (ret < 0)
>> -		goto err_add_port;
>> +	atmel_get_ip_name(&port->uart);
>>
>>   	return 0;
>>
>> --
>> 1.8.2.2
>>
>
>


-- 
Nicolas Ferre
