Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbbAZFp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:45:26 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:54346 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbbAZFpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:45:24 -0500
X-ME-Helo: [127.0.0.1]
X-ME-Date: Mon, 26 Jan 2015 06:45:23 +0100
X-ME-IP: 92.140.225.99
Message-ID: <54C5D473.4060204@wanadoo.fr>
Date: Mon, 26 Jan 2015 06:45:23 +0100
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cryptoapi,gmane.linux.kernel,gmane.linux.kernel.janitors
To: herbert@gondor.apana.org.au, davem@davemloft.net
CC: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: omap: Free memory in error path
References: <1422250858-22516-1-git-send-email-christophe.jaillet@wanadoo.fr>
In-Reply-To: <1422250858-22516-1-git-send-email-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Antivirus: avast! (VPS 150125-1, 25/01/2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oups,

should be:
      free_pages((unsigned long)buf_out, pages);
      free_pages((unsigned long)buf_in, pages);


CJ

Le 26/01/2015 06:40, Christophe Jaillet a écrit :
> If only one of the 2 __get_free_pages fails, then there is a memory leak
>
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/crypto/omap-aes.c | 2 ++
>   drivers/crypto/omap-des.c | 2 ++
>   2 files changed, 4 insertions(+)
>
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index f79dd41..c2f9333 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -577,6 +577,8 @@ static int omap_aes_copy_sgs(struct omap_aes_dev *dd)
>   	buf_out = (void *)__get_free_pages(GFP_ATOMIC, pages);
>   
>   	if (!buf_in || !buf_out) {
> +		free_page((unsigned long)buf_out);
> +		free_page((unsigned long)buf_in);
>   		pr_err("Couldn't allocated pages for unaligned cases.\n");
>   		return -1;
>   	}
> diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
> index 0b8dcf5..a2f6ca1 100644
> --- a/drivers/crypto/omap-des.c
> +++ b/drivers/crypto/omap-des.c
> @@ -570,6 +570,8 @@ static int omap_des_copy_sgs(struct omap_des_dev *dd)
>   	buf_out = (void *)__get_free_pages(GFP_ATOMIC, pages);
>   
>   	if (!buf_in || !buf_out) {
> +		free_page((unsigned long)buf_out);
> +		free_page((unsigned long)buf_in);
>   		pr_err("Couldn't allocated pages for unaligned cases.\n");
>   		return -1;
>   	}

