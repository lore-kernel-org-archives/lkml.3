Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaJNPDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:03:40 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:55364 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaJNPDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 11:03:39 -0400
Date: Tue, 14 Oct 2014 17:03:33 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ralf Hoppe <rhoppe@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/hmcdrv: Restrict s390 HMC driver to S390 arch
Message-ID: <20141014170333.788efc91@mschwide>
In-Reply-To: <20141014141342.GA30995@hansolo.jdub.homelinux.org>
References: <20141014141342.GA30995@hansolo.jdub.homelinux.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101415-0041-0000-0000-000001AA774A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2014 10:13:42 -0400
Josh Boyer <jwboyer@fedoraproject.org> wrote:

> This driver is only usable on 64-bit s390 machines.  Mark the Kconfig
> dependencies to that users on other architectures are not prompted for it.
> 
> Fixes: 8f933b1043e1e5 ("s390/hmcdrv: HMC drive CD/DVD access")
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> ---
>  drivers/s390/char/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
> index dc24ecfac2d1..db2cb1f8a1b5 100644
> --- a/drivers/s390/char/Kconfig
> +++ b/drivers/s390/char/Kconfig
> @@ -105,7 +105,7 @@ config SCLP_ASYNC
>  config HMC_DRV
>  	def_tristate m
>  	prompt "Support for file transfers from HMC drive CD/DVD-ROM"
> -	depends on 64BIT
> +	depends on S390 && 64BIT
>  	select CRC16
>  	help
>  	  This option enables support for file transfers from a Hardware

Indeed. I'll queue this patch to the fixes branch of the s390 tree.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

