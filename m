Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3KPWTL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 17:19:11 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:52551 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab3KPWTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 17:19:06 -0500
Message-ID: <1384640335.7518.12.camel@fishsauce>
Subject: Re: [tpmdd-devel] [PATCH 1/5 v2] tpm: Pull everything related to
 /dev/tpmX into tpm-dev.c
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Nov 2013 16:18:55 -0600
In-Reply-To: <1383536326-28772-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
	 <1383536326-28772-2-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111622-1344-0000-0000-00000350456D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice clean up!!! The code looks much more clean after removing the
duplicated code in all drivers.  Thanks.


> diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
> new file mode 100644
> index 0000000..8d94e97
> --- /dev/null
> +++ b/drivers/char/tpm/tpm-dev.c
> + * Copyright (C) 2013 Obsidian Reearch Corp

Typo Research?

> + * Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> + *

> +
> +int tpm_dev_add_device(struct tpm_chip *chip)
> +{

> +	rc = misc_register(&chip->vendor.miscdev);
> +	if (rc) {
> +		chip->vendor.miscdev.name = NULL;
> +		dev_warn(chip->dev,

Any reason why we use dev_warn here instead of dev_err?

> +			"unable to misc_register %s, minor %d err=%d\n",
> +			 chip->vendor.miscdev.name,
> +			 chip->vendor.miscdev.minor, rc);
> +	}
> +	return rc;
> +}
> +

Reviewed-by: Ashley Lai <adlai@linux.vnet.ibm.com>

Regards,
--Ashley Lai

