Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaEaQFK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 12:05:10 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:60946 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaEaQFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 12:05:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140531145814.GA14935@localhost>
References: <1401542051-3174-1-git-send-email-peter.senna@gmail.com>
	<20140531145814.GA14935@localhost>
Date: Sat, 31 May 2014 13:05:07 -0300
Message-ID: <CA+MoWDoeJBAOE07zsSyQj6EPqr29Mt739n8+fDwNwd1WyzynkA@mail.gmail.com>
Subject: Re: [PATCH 1/11] USB: kl5kusb105: Remove useless return variables
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 11:58 AM, Johan Hovold <jhovold@gmail.com> wrote:
> On Sat, May 31, 2014 at 10:14:01AM -0300, Peter Senna Tschudin wrote:
>> This patch remove variables that are initialized with a constant,
>> are never updated, and are only used as parameter of return.
>> Return the constant instead of using a variable.
>>
>> Verified by compilation only.
>>
>> The coccinelle script that find and fixes this issue is:
>> // <smpl>
>> @@
>> type T;
>> constant C;
>> identifier ret;
>> @@
>> - T ret = C;
>> ... when != ret
>>     when strict
>> return
>> - ret
>> + C
>> ;
>> // </smpl>
>>
>> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>>
>> ---
>>  drivers/usb/serial/kl5kusb105.c |   23 +----------------------
>>  1 file changed, 1 insertion(+), 22 deletions(-)
>>
>> diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
>> index d7440b7..2657c00 100644
>> --- a/drivers/usb/serial/kl5kusb105.c
>> +++ b/drivers/usb/serial/kl5kusb105.c
>> @@ -605,28 +605,7 @@ static int klsi_105_tiocmget(struct tty_struct *tty)
>>  static int klsi_105_tiocmset(struct tty_struct *tty,
>>                            unsigned int set, unsigned int clear)
>>  {
>> -     int retval = -EINVAL;
>> -
>> -/* if this ever gets implemented, it should be done something like this:
>> -     struct usb_serial *serial = port->serial;
>> -     struct klsi_105_private *priv = usb_get_serial_port_data(port);
>> -     unsigned long flags;
>> -     int control;
>> -
>> -     spin_lock_irqsave (&priv->lock, flags);
>> -     if (set & TIOCM_RTS)
>> -             priv->control_state |= TIOCM_RTS;
>> -     if (set & TIOCM_DTR)
>> -             priv->control_state |= TIOCM_DTR;
>> -     if (clear & TIOCM_RTS)
>> -             priv->control_state &= ~TIOCM_RTS;
>> -     if (clear & TIOCM_DTR)
>> -             priv->control_state &= ~TIOCM_DTR;
>> -     control = priv->control_state;
>> -     spin_unlock_irqrestore (&priv->lock, flags);
>> -     retval = mct_u232_set_modem_ctrl(serial, control);
>> -*/
>> -     return retval;
>> +     return -EINVAL;
>
> Your patch does a bit more than what the description says, although
> removing this out-commented code would be perfectly fine.
Sorry for that, my fault.

>
> But please just remove the entire function (and the corresponding entry
> in the struct usb_serial_driver) and update the commit message.
Sent V2.

>
> Thanks,
> Johan
>
>>  }
>>
>>  module_usb_serial_driver(serial_drivers, id_table);
>>



-- 
Peter
