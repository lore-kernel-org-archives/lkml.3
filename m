Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaJMTDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:03:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47142 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaJMTDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:03:21 -0400
MIME-Version: 1.0
In-Reply-To: <543A1055.9080801@atmel.com>
References: <1412948280-30993-1-git-send-email-ricardo.ribalda@gmail.com> <543A1055.9080801@atmel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 13 Oct 2014 21:03:00 +0200
Message-ID: <CAPybu_1kwSRfe33H9cFO_DgstP8VW=z_AcqZhhs0iQX89Mmbag@mail.gmail.com>
Subject: Re: [PATCH] tty/serial_core: Introduce lock mechanism for RS485
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nicolas

>
> I have the feeling that moving the code chunk that uses this new
> variable (rs485_enabled) here ...
>
>>       ret = uart_add_one_port(&atmel_uart, &port->uart);
>>       if (ret)
>>               goto err_add_port;
>> @@ -2574,7 +2572,7 @@ static int atmel_serial_probe(struct platform_device *pdev)
>>       device_init_wakeup(&pdev->dev, 1);
>>       platform_set_drvdata(pdev, port);
>>
>> -     if (port->uart.rs485.flags & SER_RS485_ENABLED) {
>> +     if (rs485_enabled) {
>>               UART_PUT_MR(&port->uart, ATMEL_US_USMODE_NORMAL);
>>               UART_PUT_CR(&port->uart, ATMEL_US_RTSEN);
>>       }
>
> ... (this one ^^^) up where you can test the SER_RS485_ENABLED, can be
> even simpler.
>
> otherwise, it seems good so you can add my:
>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>
> Thanks.

I supposed that the code needs to be initialized with rs485 disabled
and then enable it. Also I did not want to change the behaviour a
driver in a patch that involves 3 other drivers. If you don't mind I
prefer that this is added to a separated patch.

Thanks
