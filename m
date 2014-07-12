Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaGLHRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 03:17:49 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43475 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaGLHRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 03:17:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140711194243.GA3131@himangi-Dell>
References: <20140711194243.GA3131@himangi-Dell>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Sat, 12 Jul 2014 09:17:25 +0200
Message-ID: <CAMxnaaUA3Tb2BJ0rPXQCpYm5WnjEqEHG5f0Xsns-J7DhuU4eXA@mail.gmail.com>
Subject: Re: [PATCH] thunderbolt: Use kcalloc
To: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        julia.lawall@lip6.fr
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 9:42 PM, Himangi Saraogi <himangi774@gmail.com> wrote:
> The advantage of kcalloc is, that will prevent integer overflows
> which could result from the multiplication of number of elements
> and size and it is also a bit nicer to read.
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> A patch on top of my char-misc tree as the kzalloc version is
> already applied there.
>
>  drivers/thunderbolt/nhi.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
> index ce72f31..c68fe12 100644
> --- a/drivers/thunderbolt/nhi.c
> +++ b/drivers/thunderbolt/nhi.c
> @@ -569,12 +569,10 @@ static int nhi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>                          nhi->hop_count);
>         INIT_WORK(&nhi->interrupt_work, nhi_interrupt_work);
>
> -       nhi->tx_rings = devm_kzalloc(&pdev->dev,
> -                                    nhi->hop_count * sizeof(*nhi->tx_rings),
> -                                    GFP_KERNEL);
> -       nhi->rx_rings = devm_kzalloc(&pdev->dev,
> -                                    nhi->hop_count * sizeof(*nhi->rx_rings),
> -                                    GFP_KERNEL);
> +       nhi->tx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
> +                                    sizeof(*nhi->tx_rings), GFP_KERNEL);
> +       nhi->rx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
> +                                    sizeof(*nhi->rx_rings), GFP_KERNEL);
>         if (!nhi->tx_rings || !nhi->rx_rings)
>                 return -ENOMEM;
>
> --
> 1.9.1
>
+Greg

Acked-by: Andreas Noever <andreas.noever@gmail.com>
