Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbaDGWk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:40:57 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:1192 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034AbaDGWky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:40:54 -0400
Date: Mon, 7 Apr 2014 15:42:56 -0700
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 3/9] crypto: qce: Add dma and sg helpers
Message-ID: <20140407224256.GG17066@sonymobile.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
 <1396541886-10966-4-git-send-email-svarbanov@mm-sol.com>
 <20140403231525.GE17066@sonymobile.com>
 <533EAE81.6060109@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <533EAE81.6060109@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 03:07:13PM +0200, Stanimir Varbanov wrote:
> >> diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
> >> new file mode 100644
> >> index 000000000000..932b02fd8f25
> >> --- /dev/null
> >> +++ b/drivers/crypto/qce/dma.h
> >> @@ -0,0 +1,57 @@
> >> +/*
> >> + * Copyright (c) 2011-2014, The Linux Foundation. All rights reserved.
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 and
> >> + * only version 2 as published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + */
> >> +
> >> +#ifndef _DMA_H_
> >> +#define _DMA_H_
> >> +
> >> +#define QCE_AUTHIV_REGS_CNT		16
> >> +#define QCE_AUTH_BYTECOUNT_REGS_CNT	4
> >> +#define QCE_CNTRIV_REGS_CNT		4
> >> +
> >> +/* result dump format */
> >> +struct qce_result_dump {
> >> +	u32 auth_iv[QCE_AUTHIV_REGS_CNT];
> >> +	u32 auth_byte_count[QCE_AUTH_BYTECOUNT_REGS_CNT];
> >> +	u32 encr_cntr_iv[QCE_CNTRIV_REGS_CNT];
> >> +	u32 status;
> >> +	u32 status2;
> >> +};
> >> +
> >> +#define QCE_IGNORE_BUF_SZ	(2 * QCE_BAM_BURST_SIZE)
> > 
> > QCE_BAM_BURST_SIZE is defined in common.h in 6/9.  Either that file
> > needs to be included from this one, or the definition needs to be moved.
> 
> I decided to not include any files in driver private headers. Thus I
> include the private header files in relevant c files in order.

Actually, that is exactly what I was trying to indicate as undesirable.
Please modify this so that each individual header file doesn't require
you to include another file for usage.

-Courtney
