Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaJTLan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:30:43 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:62732 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaJTLak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:30:40 -0400
MIME-Version: 1.0
In-Reply-To: <CABuKBeL1v=E4ZSM2iq+zC2G=a1g4RT3DmJ16ra_RwQ_9ARZkZg@mail.gmail.com>
References: <1412871811-5986-1-git-send-email-matthias.bgg@gmail.com>
	<20141009215228.GA23507@kroah.com>
	<CABuKBeL1v=E4ZSM2iq+zC2G=a1g4RT3DmJ16ra_RwQ_9ARZkZg@mail.gmail.com>
Date: Mon, 20 Oct 2014 13:30:38 +0200
Message-ID: <CABuKBeKUdzZ0oxiHyo8q82qTg+fGbnJuPz1uhWQaZbou=LQg0Q@mail.gmail.com>
Subject: Re: [PATCH] tty: serial: 8250_mtk: Fix quot calculation
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jslaby@suse.cz, =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        Howard Chen <ibanezchen@gmail.com>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

2014-10-10 10:10 GMT+02:00 Matthias Brugger <matthias.bgg@gmail.com>:
> 2014-10-09 23:52 GMT+02:00 Greg KH <gregkh@linuxfoundation.org>:
>> On Thu, Oct 09, 2014 at 06:23:31PM +0200, Matthias Brugger wrote:
>>> The calculation of value quot for highspeed register set to three
>>> was wrong. This patch fixes the calculation so that the serial port
>>> for baudrates bigger then 576000 baud is working correctly.
>>>
>>> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
>>> ---
>>>  drivers/tty/serial/8250/8250_mtk.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
>>> index 1c4b4bf..4376c48 100644
>>> --- a/drivers/tty/serial/8250/8250_mtk.c
>>> +++ b/drivers/tty/serial/8250/8250_mtk.c
>>> @@ -81,7 +81,7 @@ mtk8250_set_termios(struct uart_port *port, struct ktermios *termios,
>>>               /* Set to highest baudrate supported */
>>>               if (baud >= 1152000)
>>>                       baud = 921600;
>>> -             quot = DIV_ROUND_CLOSEST(port->uartclk, 256 * baud);
>>> +             quot = (port->uartclk / (256 * baud)) + 1;
>>>       }
>>>
>>>       /*
>>
>> Has this always been incorrect, or was it caused by a specific patch?
>
> It has always been incorrect :o
>
>> Should it go to the stable kernels?  If so, how far back?
>
> No need to go to the stable kernels. The driver is only in linux-next.

Any comments on that?

Thanks,
Matthias

>
> Cheers,
> Matthias Brugger
>
>>
>> thanks,
>>
>> greg k-h
>
>
>
> --
> motzblog.wordpress.com



-- 
motzblog.wordpress.com
