Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab3FQVjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:39:11 -0400
Received: from numidia.opendz.org ([98.142.220.152]:43459 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3FQVjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:39:09 -0400
Date: Mon, 17 Jun 2013 22:38:59 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Ferruh Yigit <fery@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, ttdrivers@cypress.com,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Kees Cook <keescook@chromium.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: cyttsp - fix memcpy size param
Message-ID: <20130617213858.GA2805@dztty>
References: <1368192769-24067-1-git-send-email-fery@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368192769-24067-1-git-send-email-fery@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc'ed Kees and Greg)

Hi Dmitry,

On Fri, May 10, 2013 at 04:32:48PM +0300, Ferruh Yigit wrote:
> memcpy param is wrong because of offset in bl_cmd, this may corrupt the
> stack which may cause a crash.
> 
> Tested-by: Ferruh Yigit <fery@cypress.com> on TMA300-DVK
> Signed-off-by: Ferruh Yigit <fery@cypress.com>
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
I was going to send a patch and found that it was just fixed in todays
next-20130617

Anyway, will this overflow fix go for the next -rc?

Thanks in advance Dmitry!

-- 
Djalal Harouni
http://opendz.org
