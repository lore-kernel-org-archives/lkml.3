Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab3LTTNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:13:04 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:55989 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab3LTTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:13:00 -0500
Subject: Re: [PATCH 1/2] GenWQE: Fix endian issues detected by sparse
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: fengguang.wu@intel.com
Cc: jim.epost@gmail.com, sfr@canb.auug.org.au, gregkh@linuxfoundation.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org
In-Reply-To: <1387553171-31469-1-git-send-email-haver@linux.vnet.ibm.com>
References: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
	 <1387553171-31469-1-git-send-email-haver@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 20 Dec 2013 20:12:53 +0100
Message-ID: <1387566773.1847.28.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122019-4966-0000-0000-000007E56EF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Freitag, den 20.12.2013, 16:26 +0100 schrieb Frank Haverkamp:
> +++ b/drivers/misc/genwqe/card_utils.c
> @@ -59,7 +59,7 @@ int __genwqe_writeq(struct genwqe_dev *c
>         if (cd->mmio == NULL)
>                 return -EIO;
> 
> -       __raw_writeq(cpu_to_be64((val)), (cd->mmio + byte_offs));
> +       __raw_writeq((__force u32)cpu_to_be64(val), cd->mmio +
> byte_offs);

what a pity. I introduced here a wrong cast to u32 and not to u64 what
it should have been. I will send a fix, once I have tried it out.

Regards

Frank

