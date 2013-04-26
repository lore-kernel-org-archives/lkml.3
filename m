Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047Ab3DZAnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 20:43:00 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:43479 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758891Ab3DZAm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 20:42:59 -0400
MIME-Version: 1.0
In-Reply-To: <1366910944-3033663-11-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-11-git-send-email-arnd@arndb.de>
From: Masanori Goto <gotom@sanori.org>
Date: Thu, 25 Apr 2013 17:42:38 -0700
X-Google-Sender-Auth: gPIo6DshXCO0HbdJHmrqeoDItJk
Message-ID: <CALZLnaFeLcaGM7_McTZ=pKBRnpXk0AvqOTF=1YCqJv-53yk4XQ@mail.gmail.com>
Subject: Re: [PATCH 10/21] [SCSI] nsp32: use mdelay instead of large udelay constants
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/25 Arnd Bergmann <arnd@arndb.de>
>
> ARM cannot handle udelay for more than 2 miliseconds, so we
> should use mdelay instead for those.
>

Singed-off-by: GOTO Masanori <gotom@debian.or.jp>

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: GOTO Masanori <gotom@debian.or.jp>
> Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/nsp32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 1e3879d..0665f9c 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -2899,7 +2899,7 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
>          * reset SCSI bus
>          */
>         nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
> -       udelay(RESET_HOLD_TIME);
> +       mdelay(RESET_HOLD_TIME / 1000);
>         nsp32_write1(base, SCSI_BUS_CONTROL, 0);
>         for(i = 0; i < 5; i++) {
>                 intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */
> --
> 1.8.1.2
>
