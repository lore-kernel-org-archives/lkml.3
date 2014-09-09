Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaIISbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:31:32 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:34090 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaIISba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:31:30 -0400
MIME-Version: 1.0
In-Reply-To: <c522bdd8972633e0eb481ffc5ebb7da98b190fa7.1410273306.git.m.chehab@samsung.com>
References: <20140909124306.2d5a0d76@canb.auug.org.au> <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <c522bdd8972633e0eb481ffc5ebb7da98b190fa7.1410273306.git.m.chehab@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 9 Sep 2014 19:30:58 +0100
Message-ID: <CA+V-a8vXAWyRo+-LuEhMNfn1KWDfvy38pROYspPmRBckbFpj7A@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] vpif: Fix compilation with allmodconfig
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 3:38 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> When vpif is compiled as module, those errors happen:
>
> ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_display.ko] undefined!
> ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
>
> That's because vpif_lock symbol is not exported.
>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>
> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> index cd08e5248387..3dad5bd7fe0a 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -38,6 +38,7 @@ MODULE_LICENSE("GPL");
>  #define VPIF_CH3_MAX_MODES     2
>
>  spinlock_t vpif_lock;
> +EXPORT_SYMBOL_GPL(vpif_lock);
>
>  void __iomem *vpif_base;
>  EXPORT_SYMBOL_GPL(vpif_base);
> --
> 1.9.3
>
