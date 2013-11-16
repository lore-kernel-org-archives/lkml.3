Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3KPXxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 18:53:36 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:59897 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3KPXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 18:53:27 -0500
Message-ID: <1384645999.7518.46.camel@fishsauce>
Subject: Re: [tpmdd-devel] [PATCH 2/5 v2] tpm: Pull everything related to
 sysfs into tpm-sysfs.c
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Peter Huewe <peterhuewe@gmx.de>,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Nov 2013 17:53:19 -0600
In-Reply-To: <1383536326-28772-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1383536326-28772-1-git-send-email-jgunthorpe@obsidianresearch.com>
	 <1383536326-28772-3-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111623-7164-0000-0000-00000361BAA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
> new file mode 100644
> index 0000000..3bcfed0
> --- /dev/null
> +++ b/drivers/char/tpm/tpm-sysfs.c
> @@ -0,0 +1,318 @@
> + * Copyright (C) 2013 Obsidian Reearch Corp
Typo Research?
> + * Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> + *

> +#include "tpm.h"
> +
> +/* XXX for now this helper is duplicated in tpm.c */

I think you mean this is duplicated in tpm-interface.c.  Is there a
reason why we cannot add this to tpm.h to avoid this duplication?

> +static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
> +			    int len, const char *desc)
> +{


> +static ssize_t pubek_show(struct device *dev, struct device_attribute *attr,
> +			  char *buf)

Most of the functions in this file are moved from tpm-interface.c
without any modification to the code.  Why do we need to change the
function names in this file?  Unless there is a good reason for it
otherwise I would prefer to keep the same function names.  This is for
easy maintaining (for me at least :)) in case there are issues in the
future and we need to go back we can easily find out where they came
from.

Thanks,
--Ashley Lai

