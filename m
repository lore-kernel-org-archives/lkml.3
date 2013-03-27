Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3C0I7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:59:30 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:39994 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab3C0I71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:59:27 -0400
MIME-Version: 1.0
In-Reply-To: <1363347628-15344-1-git-send-email-sachin.kamat@linaro.org>
References: <1363347628-15344-1-git-send-email-sachin.kamat@linaro.org>
Date: Wed, 27 Mar 2013 14:29:26 +0530
Message-ID: <CAK9yfHyw+rfgpBW+JiGE4bgv3s5t3nmGxoeqzE-ystq_b+mf8A@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: adp5520: Use module_i2c_driver()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: device-drivers-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>
Cc: michael.hennerich@analog.com, sameo@linux.intel.com,
        sachin.kamat@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 March 2013 17:10, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> module_i2c_driver() removes some boilerplate and makes the code
> simple.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/mfd/adp5520.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
> index 210dd03..5ab021f 100644
> --- a/drivers/mfd/adp5520.c
> +++ b/drivers/mfd/adp5520.c
> @@ -360,17 +360,7 @@ static struct i2c_driver adp5520_driver = {
>         .id_table       = adp5520_id,
>  };
>
> -static int __init adp5520_init(void)
> -{
> -       return i2c_add_driver(&adp5520_driver);
> -}
> -module_init(adp5520_init);
> -
> -static void __exit adp5520_exit(void)
> -{
> -       i2c_del_driver(&adp5520_driver);
> -}
> -module_exit(adp5520_exit);
> +module_i2c_driver(adp5520_driver);
>
>  MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
>  MODULE_DESCRIPTION("ADP5520(01) PMIC-MFD Driver");
> --
> 1.7.4.1
>

ping...
