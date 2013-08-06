Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab3HFWDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:03:00 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:39026 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3HFWC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:02:59 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] mmc: dw_mmc: Set timeout to max upon resume
Date: Wed, 07 Aug 2013 00:02:53 +0200
Message-ID: <1598418.IPSQVP644x@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1375825071-20922-5-git-send-email-dianders@chromium.org>
References: <1373470926-19314-1-git-send-email-dianders@chromium.org> <1375825071-20922-1-git-send-email-dianders@chromium.org> <1375825071-20922-5-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 of August 2013 14:37:51 Doug Anderson wrote:
> The TMOUT register is initted to 0xffffffff at probe time but isn't
> initted after suspend/resume.  Add an init of this value.
> 
> No problems were observed without this (it will also get initted in
> __dw_mci_start_request if there is data to send), but it makes the
> register dump before and after suspend clean.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/mmc/host/dw_mmc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 0fa3135..1abcb36 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2505,6 +2505,9 @@ int dw_mci_resume(struct dw_mci *host)
>  	/* Restore the old value at FIFOTH register */
>  	mci_writel(host, FIFOTH, host->fifoth_val);
> 
> +	/* Put in max timeout */
> +	mci_writel(host, TMOUT, 0xFFFFFFFF);
> +
>  	mci_writel(host, RINTSTS, 0xFFFFFFFF);
>  	mci_writel(host, INTMASK, SDMMC_INT_CMD_DONE | SDMMC_INT_DATA_OVER 
|
>  		   SDMMC_INT_TXDR | SDMMC_INT_RXDR |

Not sure if we really care about register dumps, but if it gets 
initialized in probe as well, then this is fine.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

