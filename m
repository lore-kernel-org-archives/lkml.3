Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3EIQgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 12:36:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45779 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab3EIQgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 12:36:47 -0400
Message-ID: <518BCF4B.1060504@ti.com>
Date: Thu, 9 May 2013 11:31:07 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: <loic.pallardy@st.com>, <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv2 2/4] mailbox: Introduce a new common API
References: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org> <1367825046-6229-1-git-send-email-jaswinder.singh@linaro.org>
In-Reply-To: <1367825046-6229-1-git-send-email-jaswinder.singh@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

On 05/06/2013 02:24 AM, Jassi Brar wrote:
> +++ b/include/linux/mailbox_client.h
> @@ -0,0 +1,85 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __MAILBOX_CLIENT_H
> +#define __MAILBOX_CLIENT_H
> +
> +#include <linux/mailbox.h>
> +
> +/**
> + * struct ipc_client - User of a mailbox
> + * @chan_name: the "controller:channel" this client wants
> + * @rxcb: atomic callback to provide client the data received
> + * @txcb: atomic callback to tell client of data transmission
> + * @tx_block: if the ipc_send_message should block until data is transmitted
> + * @tx_tout: Max block period in ms before TX is assumed failure
> + * @knows_txdone: if the client could run the TX state machine. Usually if
> + *    the client receives some ACK packet for transmission. Unused if the
> + *    controller already has TX_Done/RTR IRQ.
> + * @cntlr_data: Optional controller specific parameters during channel request
> + */
> +struct ipc_client {
> +	char *chan_name;
> +	void (*rxcb)(void *data);
> +	void (*txcb)(request_token_t t, enum xfer_result r);

We have to introduce a callback data pointer, so that the calling
clients can retrieve a context object variable or some other useful
data within the callback functions, just like most normal callback
function declarations and registrations do.

> +	bool tx_block;
> +	unsigned long tx_tout;
> +	bool knows_txdone;
> +	void *cntlr_data;
> +};

regards
Suman




