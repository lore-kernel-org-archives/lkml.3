Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbaGYJN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:13:26 -0400
Received: from mail-wi0-f193.google.com ([209.85.212.193]:33815 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaGYJNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:13:22 -0400
Date: Fri, 25 Jul 2014 11:13:14 +0200
From: Christophe RICARD <christophe.ricard@gmail.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] NFC: st21nfca: Remove double assignment of .owner in
 struct device_driver
Message-ID: <20140725111314.0578f122@toffy-MacBookPro>
In-Reply-To: <1401718860-10901-1-git-send-email-emilgoode@gmail.com>
References: <1401718860-10901-1-git-send-email-emilgoode@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Jun 2014 16:21:00 +0200
Emil Goode <emilgoode@gmail.com> wrote:

> The .owner member of struct device_driver is assigned THIS_MODULE
> twice.
> 
> Introduced by:
> 
> commit c44cb2edd01ca31471d9385f0895891b006ab904
> ("NFC: dts: st21nfca: Add device-tree (Open Firmware) support to
> st21nfca")
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>  drivers/nfc/st21nfca/i2c.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
> index 3f954ed..95942ca 100644
> --- a/drivers/nfc/st21nfca/i2c.c
> +++ b/drivers/nfc/st21nfca/i2c.c
> @@ -710,7 +710,6 @@ static struct i2c_driver st21nfca_hci_i2c_driver
> = { .driver = {
>  		.owner = THIS_MODULE,
>  		.name = ST21NFCA_HCI_I2C_DRIVER_NAME,
> -		.owner = THIS_MODULE,
>  		.of_match_table =
> of_match_ptr(of_st21nfca_i2c_match), },
>  	.probe = st21nfca_hci_i2c_probe,

Acked-by: Christophe RICARD <christophe-h.ricard@st.com>
