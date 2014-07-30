Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaG3OwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:52:17 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:49120 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaG3OwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:52:15 -0400
MIME-Version: 1.0
In-Reply-To: <53D90340.3010000@suse.cz>
References: <1406729236-19887-1-git-send-email-sudipm.mukherjee@gmail.com>
	<53D90340.3010000@suse.cz>
Date: Wed, 30 Jul 2014 20:22:14 +0530
Message-ID: <CADVatmOooxEKJ26i9nED2OKmBghOwuz6fjGJmYO0tuopTEoLDw@mail.gmail.com>
Subject: Re: [PATCH] tty: serial: serial_core.c: printk replacement
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 8:07 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 07/30/2014, 04:07 PM, Sudip Mukherjee wrote:
>> printk replaced with corresponding dev_*
>> fixed two broken user-visible strings used by the corresponding printk
>>
>>
>> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
>> ---
>>  drivers/tty/serial/serial_core.c | 19 ++++++++++---------
>>  1 file changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
>> index 8bb19da..ef48d0f 100644
>> --- a/drivers/tty/serial/serial_core.c
>> +++ b/drivers/tty/serial/serial_core.c
> ...
>> @@ -1974,8 +1974,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
>>               for (tries = 3; !ops->tx_empty(uport) && tries; tries--)
>>                       msleep(10);
>>               if (!tries)
>> -                     printk(KERN_ERR "%s%s%s%d: Unable to drain "
>> -                                     "transmitter\n",
>> +                     dev_err(uport->dev,
>> +                             "%s%s%s%d: Unable to drain transmitter\n",
>>                              uport->dev ? dev_name(uport->dev) : "",
>
> Hi, this does not look correct. You use uport->dev, but there is a test
> whether it is NULL in the parameters.
>
> You would have to investigate if and when uport->dev can be NULL and
> document it in the commit log above.

HI
Thanks for reviewing it . I am checking out all the cases in which
uport can be null and will resend the patch.

Thanks
Sudip

>
> thanks,
> --
> js
> suse labs
