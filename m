Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbbA0UPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:15:47 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:61716 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754AbbA0UPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:15:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Cc: wim@iguana.be, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, paul@crapouillou.net
Subject: Re: [PATCH 2/2] watchdog: jz4740: Add DT support
Date: Tue, 27 Jan 2015 21:15:37 +0100
Message-ID: <2690526.hgsE0j4AZc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422371490-44402-3-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422371490-44402-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422371490-44402-3-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Odb+mhRftlHU6mqlW5spb0Jz7vAO5TT0kisow8EXsayVD20rdhl
 gb4aNCUkXurNUh58tRGQ1g820FKyxEFhsMeuuyf49l3NP0Emz4wCdk7F5wlglWOF6QRyFbx
 tcty+PeHdymP2Idh1bab0eT6sw37emnN7zyY74cR5szZG7NPqKP7mcya+fL39YASj8VV6Qn
 rlzQcC05nPn2w9WdxrcMg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2015 15:11:30 Zubair Lutfullah Kakakhel wrote:
>  };
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id jz4740_of_matches[] = {
> +       { .compatible = "ingenic,jz4740-watchdog", },
> +       { /* sentinel */ }
> +};
> +#endif
> +
>  static int jz4740_wdt_probe(struct platform_device *pdev)
>  {
>         struct jz4740_wdt_drvdata *drvdata;
> @@ -211,6 +219,7 @@ static struct platform_driver jz4740_wdt_driver = {
>         .remove = jz4740_wdt_remove,
>         .driver = {
>                 .name = "jz4740-wdt",
> +               .of_match_table = of_match_ptr(jz4740_of_matches),
>         },
> 

Why the #ifdef? Presumably we want to move over jz4740 to DT-only in the
long run, so you could just remove the #ifdef and the of_match_ptr()
wrapper.

Also, you should add a MODULE_DEVICE_TABLE() entry.

	Arnd
