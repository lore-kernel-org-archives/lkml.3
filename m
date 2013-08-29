Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3H2NnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 09:43:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53094 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab3H2NnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 09:43:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH RFC v2 15/16] clk: vt8500: remove call to of_clk_init
Date: Thu, 29 Aug 2013 15:42:26 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-16-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1377638890-371-16-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308291542.26480.arnd@arndb.de>
X-Provags-ID: V02:K0:yfyOZlxCH+rG5YYeUX2u+DRz9DpI7bXoqOIvFIOgYNw
 ZsAjFgQ0hPVKrCoYWaKEmQcRdibHPfIiT5cMWId/XHk+uBFw7s
 39Xp1utQ317iF1Q+MdFLmFJNk2IDZy1SgA6AYvv6YUEqoVGnSp
 pLCHvyj7HsJfDeLhz1lRwkvKQ9eOBYQMIWL1UBBBDxYDMiRbCa
 OWF3SQjoF7e4NB6Fl9f1vBDx+L1XoG2F1k7B8PjHPZ11aQ/amo
 GUsTZn7BzB5y9YenT+f6JpqamIlB6SykUhiDCC0zKoB08wGcqr
 KMa5vYzq6J1Z8c3/SHgUCFaoB4KTHCU7Iwjh/cWhNXQzYnNidy
 OJ3hkfwrBjrztzEejgRI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 August 2013, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove it from corresponding drivers/clk code.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clk/clk-vt8500.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
> index 82306f5..218d7ba 100644
> --- a/drivers/clk/clk-vt8500.c
> +++ b/drivers/clk/clk-vt8500.c
> @@ -701,6 +701,4 @@ void __init vtwm_clk_init(void __iomem *base)
>                 return;
>  
>         pmc_base = base;
> -
> -       of_clk_init(NULL);
>  }

This looks suspicious: of_clk_init must be called after assigning pmc_base
in this driver. I think you should better do the same thing you did for
highbank and move the initialization into the clk driver.

	Arnd
