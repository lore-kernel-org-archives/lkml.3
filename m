Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaKRQnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:43:43 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:43301 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaKRQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:43:40 -0500
MIME-Version: 1.0
In-Reply-To: <20141118162544.GB1108@kroah.com>
References: <1416293401-7714-1-git-send-email-kiran.kumar@linaro.org>
	<20141118162544.GB1108@kroah.com>
Date: Tue, 18 Nov 2014 22:13:39 +0530
Message-ID: <CA+RfmHY=bmkzpgABVe_ayXASpNhPLKrQErw=10KjqhwQ0xPu_A@mail.gmail.com>
Subject: Re: [RFC] serial_core: Add wake_peer uart operation
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, San Mehat <san@google.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2014 21:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 18, 2014 at 12:20:01PM +0530, Kiran Kumar Raparthy wrote:
>> From: San Mehat <san@google.com>
>>
>> serial_core: Add wake_peer uart operation
>>
>> Add wake_peer which is called before starting UART TX. The idea here
>> is to provide a mechanism where we can wakeup our peer before sending
>> data.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Jiri Slaby <jslaby@suse.cz>
>> Cc: linux-serial@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Cc: John Stultz <john.stultz@linaro.org>
>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> Signed-off-by: San Mehat <san@google.com>
>> [Kiran: Added context to commit message]
>> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
>> ---
>> This is one of the number of patches from the Android AOSP common.git tree,
>> which is used on almost all Android devices.  I wanted to submit it for review
>> to see if it should go upstream.
>>
>>  drivers/tty/serial/serial_core.c | 3 +++
>>  include/linux/serial_core.h      | 1 +
>>  2 files changed, 4 insertions(+)
>>
>> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
>> index df3a8c7..dc45c4b 100644
>> --- a/drivers/tty/serial/serial_core.c
>> +++ b/drivers/tty/serial/serial_core.c
>> @@ -95,6 +95,9 @@ static void __uart_start(struct tty_struct *tty)
>>       struct uart_state *state = tty->driver_data;
>>       struct uart_port *port = state->uart_port;
>>
>> +     if (port->ops->wake_peer)
>> +             port->ops->wake_peer(port);
>> +
>>       if (!uart_tx_stopped(port))
>>               port->ops->start_tx(port);
>>  }
>> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
>> index 21c2e05..219b6a3 100644
>> --- a/include/linux/serial_core.h
>> +++ b/include/linux/serial_core.h
>> @@ -66,6 +66,7 @@ struct uart_ops {
>>       void            (*set_ldisc)(struct uart_port *, int new);
>>       void            (*pm)(struct uart_port *, unsigned int state,
>>                             unsigned int oldstate);
>> +     void            (*wake_peer)(struct uart_port *);
>>
>>       /*
>>        * Return a string describing the type of the port
>
> Do you have a driver that uses this callback to submit?  I really don't
> like taking hooks that are not used in the tree, otherwise it usually
> gets removed by someone who says, "look this hook isn't being used,
> let's delete it!"
Okay,let me check and resubmit the patch which uses the callback in driver.
Thanks for the review comments.
Regards,
Kiran
>
> thanks,
>
> greg k-h
