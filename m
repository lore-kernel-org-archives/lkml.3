Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3EJN42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:56:28 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:64212 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab3EJN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:56:27 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.153.142]
In-Reply-To: <1368192769-24067-1-git-send-email-fery@cypress.com>
References: <1368192769-24067-1-git-send-email-fery@cypress.com>
Date: Fri, 10 May 2013 15:56:25 +0200
Message-ID: <CABxcv==jenFd=4NPme0y274SdmAkVMFQRqNgOFDJa33ptzinVg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input: cyttsp - fix memcpy size param
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Ferruh Yigit <fery@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, ttdrivers@cypress.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ferruh,

On Fri, May 10, 2013 at 3:32 PM, Ferruh Yigit <fery@cypress.com> wrote:
> memcpy param is wrong because of offset in bl_cmd, this may corrupt the
> stack which may cause a crash.
>
> Tested-by: Ferruh Yigit <fery@cypress.com> on TMA300-DVK
> Signed-off-by: Ferruh Yigit <fery@cypress.com>

Nice catch, thanks for fixing it

Acked-by: Javier Martinez Canillas <javier@dowhile0.org>

> ---
>  drivers/input/touchscreen/cyttsp_core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
> index 8e60437..97ba891 100644
> --- a/drivers/input/touchscreen/cyttsp_core.c
> +++ b/drivers/input/touchscreen/cyttsp_core.c
> @@ -133,7 +133,7 @@ static int cyttsp_exit_bl_mode(struct cyttsp *ts)
>         memcpy(bl_cmd, bl_command, sizeof(bl_command));
>         if (ts->pdata->bl_keys)
>                 memcpy(&bl_cmd[sizeof(bl_command) - CY_NUM_BL_KEYS],
> -                       ts->pdata->bl_keys, sizeof(bl_command));
> +                       ts->pdata->bl_keys, CY_NUM_BL_KEYS);
>
>         error = ttsp_write_block_data(ts, CY_REG_BASE,
>                                       sizeof(bl_cmd), bl_cmd);
> --
> 1.7.9.5
>
> This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.

In the future can you please drop this footer? It has no point to
state the above when you send emails to a public mailing list.

Best regards,
Javier
