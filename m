Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaI3RkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:40:14 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:37365 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI3RkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:40:12 -0400
MIME-Version: 1.0
In-Reply-To: <1412097587-2779-1-git-send-email-karthik.188@gmail.com>
References: <1412097587-2779-1-git-send-email-karthik.188@gmail.com>
Date: Tue, 30 Sep 2014 14:40:10 -0300
Message-ID: <CAOMZO5DOph+nX6UChuWcBnZ_To6=H96ObH0RdYND4g6ooptaeQ@mail.gmail.com>
Subject: Re: [PATCH] staging: et131x: remove unneccessary 'out of memory' message
From: Fabio Estevam <festevam@gmail.com>
To: Karthik Nayak <karthik.188@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        gamerh2o@gmail.com, Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 2:19 PM, Karthik Nayak <karthik.188@gmail.com> wrote:
> Removes the 'out of memory' warning issues by checkpatch
>
> Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
> ---
>  drivers/staging/et131x/et131x.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> index 41fcaa0..f1a9296 100644
> --- a/drivers/staging/et131x/et131x.c
> +++ b/drivers/staging/et131x/et131x.c
> @@ -2423,7 +2423,6 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
>
>         skb = dev_alloc_skb(rfd->len + 2);
>         if (!skb) {
> -               dev_err(&adapter->pdev->dev, "Couldn't alloc an SKB for Rx\n");
>                 return NULL;
>         }

Then you could also remove the braces:

if (!skb)
      return NULL;
