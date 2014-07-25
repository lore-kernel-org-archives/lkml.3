Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbaGYKt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:49:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50373 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaGYKtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:49:55 -0400
Date: Fri, 25 Jul 2014 13:49:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Seunghun Lee <waydi1@gmail.com>
Cc: gregkh@linuxfoundation.org, lidza.louina@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: dgng: Fix Macros with complex values should
 be enclosed in parenthesis
Message-ID: <20140725104932.GW25880@mwanda>
References: <1406215613-9314-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406215613-9314-1-git-send-email-waydi1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 12:26:51AM +0900, Seunghun Lee wrote:
> This patch fixes a checkpatch errors
> "Macros with complex values should be enclosed in parenthesis"
> 
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  drivers/staging/dgnc/dgnc_driver.h |   40 ++++++++++++------------
>  drivers/staging/dgnc/digi.h        |   60 ++++++++++++++++++------------------
>  drivers/staging/dgnc/dpacompat.h   |   12 ++++----
>  3 files changed, 56 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/staging/dgnc/dgnc_driver.h b/drivers/staging/dgnc/dgnc_driver.h
> index fe5ea90..f7730a1 100644
> --- a/drivers/staging/dgnc/dgnc_driver.h
> +++ b/drivers/staging/dgnc/dgnc_driver.h
> @@ -111,32 +111,32 @@
>  #endif
>  
>  #if defined TRC_TO_KMEM
> -#define PRINTF_TO_KMEM(args) dgnc_tracef args
> +#define PRINTF_TO_KMEM(args) do { dgnc_tracef args } while (0)

This is *so* nasty...  I suspect the only reason it works is because
TRC_TO_KMEM is never defined.

regards,
dan carpenter

