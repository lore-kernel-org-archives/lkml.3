Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab3E0UCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 16:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab3E0UCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 16:02:19 -0400
Message-ID: <51A3BCA9.70209@redhat.com>
Date: Mon, 27 May 2013 16:06:01 -0400
From: Tony Camuso <tcamuso@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        LeonidasDaSilvaBarbosa <leosilva@linux.vnet.ibm.com>,
        AshleyLai <ashley@ashleylai.com>, sfr@canb.auug.org.au
Subject: Re: [PATCH] tpm: fix regression caused by section type conflict of
 tpm_dev_release() in ppc builds
References: <51A39A0C.8040405@redhat.com> <1369684307-11014-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1369684307-11014-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 03:51 PM, Peter Huewe wrote:
> The 8119807 commit reintroduced a regression
> (error: __ksymtab_tpm_dev_release causes a section type conflict) that was fixed by commit
> cbb2ed4.
> Fix it for good by adding the prototype to tpm.h so sparse doesn't
> complain about it anymore.
> 
> Reported-by: Tony Camuso <tcamuso@redhat.com>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> James, can you please take this one directly and push it to next please?
> As it causes a build failure on ppc
> 
>  drivers/char/tpm/tpm.c | 2 +-
>  drivers/char/tpm/tpm.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 7c3b3dc..e3c974a 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -1472,7 +1472,7 @@ EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
>   * Once all references to platform device are down to 0,
>   * release all allocated structures.
>   */
> -static void tpm_dev_release(struct device *dev)
> +void tpm_dev_release(struct device *dev)
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 4334232..a7bfc17 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -332,6 +332,7 @@ extern struct tpm_chip* tpm_register_hardware(struct device *,
>  				 const struct tpm_vendor_specific *);
>  extern int tpm_open(struct inode *, struct file *);
>  extern int tpm_release(struct inode *, struct file *);
> +extern void tpm_dev_release(struct device *dev);
>  extern void tpm_dev_vendor_release(struct tpm_chip *);
>  extern ssize_t tpm_write(struct file *, const char __user *, size_t,
>  			 loff_t *);
> 

Thanks, Peter. I should've mentioned that it didn't cause problems
with x86 build, only with ppc. 




