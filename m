Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaBUITw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:19:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48147 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaBUITv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:19:51 -0500
Date: Fri, 21 Feb 2014 11:19:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com,
        Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v1.3 10/11] arcmsr: Fixed coding style errors and white
 space change
Message-ID: <20140221081933.GH26776@mwanda>
References: <CAKiknE-FJg9y7CTMbvow277mr=H+oKkBLjDc1qDYjhHtpfBdZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKiknE-FJg9y7CTMbvow277mr=H+oKkBLjDc1qDYjhHtpfBdZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:35:58PM +0800, 黃清隆 wrote:
> From: Ching <ching2048@areca.com.tw>
> 
> Fixed coding style errors and white space change.
> 

This doesn't *just* do that.  It also has code changes.

> -static void arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
> +static void
> +arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
>  {
>         struct MessageUnit_C __iomem *reg = pACB->pmuC;
> -       int retry_count = 30;/* enlarge wait flush adapter cache time:
> 10 minute */
> +       int retry_count = 6;
> +
>         writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
>         writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
> +       readl(&reg->inbound_doorbell);
> +       readl(&reg->inbound_msgaddr0);


We also change the printed driver string and there are other code
changes as well.

regards,
dan carpenter

