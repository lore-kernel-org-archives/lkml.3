Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab3EMOaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:30:01 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:65036 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3EMO37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:29:59 -0400
MIME-Version: 1.0
In-Reply-To: <1368044622-25645-1-git-send-email-geert@linux-m68k.org>
References: <1368044622-25645-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 13 May 2013 07:29:59 -0700
Message-ID: <CAHQ1cqFrJL6vBSpx7HXYYEE040=Lz8Qnqo2gjSMTUnMQCfygRw@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] v4l2: SI476X MFD - Do not use binary constants
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 1:23 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Gcc < 4.3 doesn't understand binary constanrs (0b*):
>
> drivers/media/radio/radio-si476x.c:862:20: error: invalid suffix "b10000000" on integer constant
>
> Hence use a hexadecimal constant (0x*) instead.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org

Acked-by: Andrey Smirnov <andrew.smirnov@gmail.com>

> ---
>  drivers/media/radio/radio-si476x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
> index 9430c6a..9dc8baf 100644
> --- a/drivers/media/radio/radio-si476x.c
> +++ b/drivers/media/radio/radio-si476x.c
> @@ -44,7 +44,7 @@
>
>  #define FREQ_MUL (10000000 / 625)
>
> -#define SI476X_PHDIV_STATUS_LINK_LOCKED(status) (0b10000000 & (status))
> +#define SI476X_PHDIV_STATUS_LINK_LOCKED(status) (0x80 & (status))
>
>  #define DRIVER_NAME "si476x-radio"
>  #define DRIVER_CARD "SI476x AM/FM Receiver"
> --
> 1.7.0.4
>
