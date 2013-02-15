Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab3BOTrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:47:37 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:38178 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3BOTrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:47:36 -0500
MIME-Version: 1.0
In-Reply-To: <1360956981-1112-1-git-send-email-rydberg@euromail.se>
References: <1360956981-1112-1-git-send-email-rydberg@euromail.se>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 15 Feb 2013 11:47:14 -0800
X-Google-Sender-Auth: ZtzkDFp7RNTLH11c8C-lzOyhUBk
Message-ID: <CAGS+omCbbD2-gi+9oN74QFh+kskTOYPqwbOcPORRCCyhVdPiTw@mail.gmail.com>
Subject: Re: [PATCH 1/2] Input: MT - do not apply filtering on emulated events
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 11:36 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> The pointer emulation events are derived from contact values that
> have already been filtered, so send the emulated events as is.
>
> Reported-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Hi Henrik,
Brilliant!  Glad there is now such an easy fix for this.

Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>

> ---
>  drivers/input/input-mt.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
> index 1abbc17..1b7f4d4 100644
> --- a/drivers/input/input-mt.c
> +++ b/drivers/input/input-mt.c
> @@ -18,6 +18,7 @@ static void copy_abs(struct input_dev *dev, unsigned int dst, unsigned int src)
>  {
>         if (dev->absinfo && test_bit(src, dev->absbit)) {
>                 dev->absinfo[dst] = dev->absinfo[src];
> +               dev->absinfo[dst].fuzz = 0;
>                 dev->absbit[BIT_WORD(dst)] |= BIT_MASK(dst);
>         }
>  }
> --
> 1.8.1.2
