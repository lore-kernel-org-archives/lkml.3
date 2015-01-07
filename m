Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbbAGSjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:39:11 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:46174 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbbAGSjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:39:09 -0500
MIME-Version: 1.0
In-Reply-To: <1420394696-20099-1-git-send-email-me@mortis.eu>
References: <1420394696-20099-1-git-send-email-me@mortis.eu>
Date: Wed, 7 Jan 2015 20:39:08 +0200
Message-ID: <CAHp75VdrZrX7CyqcJUM5ZB8+yS4s=PR5xeGVvY+jgJp_wdxqGQ@mail.gmail.com>
Subject: Re: [PATCH] Fix an infinite retry-loop
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Giel van Schijndel <me@mortis.eu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>,
        "supporter:QLOGIC QLA3XXX NE..." <linux-driver@qlogic.com>,
        "open list:QLOGIC QLA3XXX NE..." <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 8:04 PM, Giel van Schijndel <me@mortis.eu> wrote:
> This was clearly intended as a retry-10-times loop, but due to the
> absence of code incrementing the loop-counter it was practically a
> retry-forever loop.
>
> Rewritten it as a for-loop as well to make the loop-counter increment
> (as well as its potential absence) easier to spot.

It's already in upstream in better form.

> ---
>  drivers/net/ethernet/qlogic/qla3xxx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
> index c2f09af..35a26c9 100644
> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
> @@ -144,9 +144,9 @@ static int ql_sem_lock(struct ql3_adapter *qdev, u32 sem_mask, u32 sem_bits)
>   */
>  static int ql_wait_for_drvr_lock(struct ql3_adapter *qdev)
>  {
> -       int i = 0;
> +       int i;
>
> -       while (i < 10) {
> +       for (i = 0; i < 10; ++i) {
>                 if (i)
>                         ssleep(1);
>
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
