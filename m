Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaIXQWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:22:42 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:34170 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaIXQWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:22:41 -0400
Date: Wed, 24 Sep 2014 10:22:33 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: peterhuewe@gmx.de, ashley@ashleylai.com, tpmdd@selhorst.net,
        kiran.padwal21@gmail.com, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] char: tpm: Add missing error check for
 devm_kzalloc
Message-ID: <20140924162233.GB8898@obsidianresearch.com>
References: <1411110879-4106-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411110879-4106-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 12:44:39PM +0530, Kiran Padwal wrote:
> Currently these driver are missing a check on the return value of devm_kzalloc,
> which would cause a NULL pointer dereference in a OOM situation.
> 
> This patch adds a missing check for tpm_i2c_atmel.c and tpm_i2c_nuvoton.c

Yes, my bad, thank you:

Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
>  drivers/char/tpm/tpm_i2c_atmel.c   |    4 ++++
>  drivers/char/tpm/tpm_i2c_nuvoton.c |    5 +++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
> index 7727292..503a85a 100644
> +++ b/drivers/char/tpm/tpm_i2c_atmel.c
> @@ -168,6 +168,10 @@ static int i2c_atmel_probe(struct i2c_client *client,
>  
>  	chip->vendor.priv = devm_kzalloc(dev, sizeof(struct priv_data),
>  					 GFP_KERNEL);
> +	if (!chip->vendor.priv) {
> +		rc = -ENOMEM;
> +		goto out_err;
> +	}
>  
>  	/* Default timeouts */
>  	chip->vendor.timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
> diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
> index 7b158ef..23c7b13 100644
> +++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
> @@ -538,6 +538,11 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
>  
>  	chip->vendor.priv = devm_kzalloc(dev, sizeof(struct priv_data),
>  					 GFP_KERNEL);
> +	if (!chip->vendor.priv) {
> +		rc = -ENOMEM;
> +		goto out_err;
> +	}
> +
>  	init_waitqueue_head(&chip->vendor.read_queue);
>  	init_waitqueue_head(&chip->vendor.int_queue);
>  
