Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3IRTYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:24:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39546 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IRTYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:24:01 -0400
MIME-Version: 1.0
X-Originating-IP: [64.196.191.133]
In-Reply-To: <87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>
References: <5230cf49.xeAraX9UUfBD+Brs%fengguang.wu@intel.com>
	<87B0A48E21A1974AB4780BA3191524C20E62C5@MYMBX4.stec-inc.ad>
	<52332E6B.9060405@kernel.dk>
	<87B0A48E21A1974AB4780BA3191524C20E6446@MYMBX4.stec-inc.ad>
Date: Wed, 18 Sep 2013 12:24:00 -0700
Message-ID: <CAOesGMitSuW2kKAMbPGxCp2k5FECv0yE0978VfGo9thx-q+D_g@mail.gmail.com>
Subject: Re: [block:for-next 5/6] drivers/block/skd_main.c:441:3: error:
 implicit declaration of function 'readq'
From: Olof Johansson <olof@lixom.net>
To: Akhil Bhansali <AkhilAshok.Bhansali@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, kbuild test robot <fengguang.wu@intel.com>,
        OS Engineering <osengineering@stec-inc.com>,
        Ramprasad Chinthekindi <Ramprasad.Chinthekindi@hgst.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Amit Phansalkar <Amit.Phansalkar@hgst.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 3:05 AM, Akhil Bhansali
<AkhilAshok.Bhansali@hgst.com> wrote:
> Hi Jens,
>
> Please accept this patch that takes care of warnings related to i386 compilation.
> 1. Implicit function declaration of readq and writeq.
> 2. Format related warnings for VPRINTK.
> ----
> From f9964257c83f224c120ecb1e5a7b25e1807efea8 Mon Sep 17 00:00:00 2001
> From: Akhil Bhansali <bhansaliakhil@gmail.com>
> Date: Wed, 18 Sep 2013 15:28:39 +0530
> Subject: [PATCH] block: skd: Changes to fix warnings during i386 compilation.
>
> 1. This commit addresses warnings related to
> readq, writeq implicit function declaration.
> 2. Warnings related to mismatched format.
> Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
> ---
>  drivers/block/skd_main.c |   19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
> index 773e793..0f25830 100644
> --- a/drivers/block/skd_main.c
> +++ b/drivers/block/skd_main.c
> @@ -49,6 +49,7 @@
>  #include <linux/io.h>
>  #include <linux/uaccess.h>
>  #include <asm-generic/unaligned.h>
> +#include <asm-generic/io-64-nonatomic-lo-hi.h>
>
>  #include "skd_s1120.h"
>
> @@ -4557,7 +4558,7 @@ static int skd_cons_skmsg(struct skd_device *skdev)
>         u32 i;
>
>         VPRINTK(skdev, "skmsg_table kzalloc, struct %lu, count %u total %lu\n",
> -               sizeof(struct skd_fitmsg_context),
> +               (unsigned long) sizeof(struct skd_fitmsg_context),

Just change the format string instead, then you don't have to cast
like this everywhere.


-Olof
