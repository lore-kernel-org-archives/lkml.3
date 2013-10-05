Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab3JECOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 22:14:19 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48824 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab3JECOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 22:14:17 -0400
Message-ID: <1380939244.23565.6.camel@fishsauce>
Subject: Re: [tpmdd-devel] [PATCH 06/13] tpm: Remove redundant
 dev_set_drvdata
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Date: Fri, 04 Oct 2013 21:14:04 -0500
In-Reply-To: <1379960083-8942-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
	 <1379960083-8942-7-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100502-0320-0000-0000-0000014004DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 12:14 -0600, Jason Gunthorpe wrote:
> TPM drivers should not call dev_set_drvdata (or aliases), only the core
> code is allowed to call dev_set_drvdata, and it does it during
> tpm_register_hardware.
> 
> These extra sets are harmless, but are an anti-pattern that many drivers
> have copied.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

> diff --git a/drivers/char/tpm/tpm_spi_stm_st33.c b/drivers/char/tpm/tpm_spi_stm_st33.c
> index 8d3e8e2..f5e3cd6 100644
> --- a/drivers/char/tpm/tpm_spi_stm_st33.c
> +++ b/drivers/char/tpm/tpm_spi_stm_st33.c
> @@ -779,7 +779,6 @@ tpm_st33_spi_probe(struct spi_device *dev)
>  	tpm_get_timeouts(chip);
> 
>  	/* attach chip datas to client */
Looks good except this comment needs to be removed.  Since this driver
is not merged, please remove this line in the new driver.

> -	spi_set_drvdata(dev, chip);
>  	platform_data->bchipf = false;
> 

Acked-by: Ashley Lai <adlai@linux.vnet.ibm.com>

Thanks,
--Ashley Lai


