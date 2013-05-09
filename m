Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3EIQlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:41:14 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:58597 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3EIQlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:41:11 -0400
MIME-Version: 1.0
In-Reply-To: <518BCF4B.1060504@ti.com>
References: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org>
	<1367825046-6229-1-git-send-email-jaswinder.singh@linaro.org>
	<518BCF4B.1060504@ti.com>
Date: Thu, 9 May 2013 22:11:10 +0530
Message-ID: <CAJe_Zhd=FDV3YP=XR8Yay1iy_geAt3tqj+diUxrVkd2BFSfb-g@mail.gmail.com>
Subject: Re: [PATCHv2 2/4] mailbox: Introduce a new common API
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        "Loic PALLARDY (loic.pallardy@st.com)" <loic.pallardy@st.com>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2013 22:01, Suman Anna <s-anna@ti.com> wrote:
> Hi Jassi,
>
> On 05/06/2013 02:24 AM, Jassi Brar wrote:
>> +++ b/include/linux/mailbox_client.h
>> @@ -0,0 +1,85 @@
>> +/*
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __MAILBOX_CLIENT_H
>> +#define __MAILBOX_CLIENT_H
>> +
>> +#include <linux/mailbox.h>
>> +
>> +/**
>> + * struct ipc_client - User of a mailbox
>> + * @chan_name: the "controller:channel" this client wants
>> + * @rxcb: atomic callback to provide client the data received
>> + * @txcb: atomic callback to tell client of data transmission
>> + * @tx_block: if the ipc_send_message should block until data is transmitted
>> + * @tx_tout: Max block period in ms before TX is assumed failure
>> + * @knows_txdone: if the client could run the TX state machine. Usually if
>> + *    the client receives some ACK packet for transmission. Unused if the
>> + *    controller already has TX_Done/RTR IRQ.
>> + * @cntlr_data: Optional controller specific parameters during channel request
>> + */
>> +struct ipc_client {
>> +     char *chan_name;
>> +     void (*rxcb)(void *data);
>> +     void (*txcb)(request_token_t t, enum xfer_result r);
>
> We have to introduce a callback data pointer, so that the calling
> clients can retrieve a context object variable or some other useful
> data within the callback functions, just like most normal callback
> function declarations and registrations do.
>
I meant the request_token_t for the purpose. That's how we do with DMAEngine.

Regards,
-Jassi
