Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaJHLto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:49:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18578 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923AbaJHLiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:38:19 -0400
Date: Wed, 8 Oct 2014 14:37:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: dgap: introduce dgap_stop()
Message-ID: <20141008113735.GQ23154@mwanda>
References: <20141008111356.GA22023@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008111356.GA22023@devel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All three of these patches are good and a nice improvement.  This one is
a good bugfix.  I have some notes for later, though below.

On Wed, Oct 08, 2014 at 08:13:56PM +0900, Daeseok Youn wrote:
> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
> index 7c79fe6..00f34b5 100644
> --- a/drivers/staging/dgap/dgap.c
> +++ b/drivers/staging/dgap/dgap.c
> @@ -71,6 +71,7 @@ MODULE_DESCRIPTION("Driver for the Digi International EPCA PCI based product lin
>  MODULE_SUPPORTED_DEVICE("dgap");
>  
>  static int dgap_start(void);
> +static void dgap_stop(void);

These kinds of forward declarations are annoying.  The whole file needs
to be re-arranged so that we don't have to deal with them.

> @@ -561,6 +563,21 @@ failed_class:
>  	return rc;
>  }
>  
> +static void dgap_stop(void)
> +{
> +	ulong lock_flags;

This is non-standard.  Traditionally it would be:

	unsigned long flags;

regards,
dan carpenter

