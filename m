Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab3G3J1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:27:48 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49405 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3G3J1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:27:47 -0400
MIME-Version: 1.0
In-Reply-To: <51F7844F.60904@huawei.com>
References: <51F7844F.60904@huawei.com>
Date: Tue, 30 Jul 2013 12:27:45 +0300
Message-ID: <CAEnQRZBX8rogCbYApgjdP4gEV=e3k=bCzLSUNP+abGsVOTQafA@mail.gmail.com>
Subject: Re: [PATCH] net: fix build warning in trans_rdma.c
From: Daniel Baluta <daniel.baluta@gmail.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        davem@davemloft.net, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 12:15 PM, Xishi Qiu <qiuxishi@huawei.com> wrote:
> When building v3.11-rc3, I get the following warning:
> ...
> net/9p/trans_rdma.c:594: warning: ‘rdma_cancelled’ defined but not used
> ...
> As the function is not be used, so remove it.
>
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  net/9p/trans_rdma.c |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
>
> diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
> index 928f2bb..8f68df5 100644
> --- a/net/9p/trans_rdma.c
> +++ b/net/9p/trans_rdma.c
> @@ -588,17 +588,6 @@ static int rdma_cancel(struct p9_client *client, struct p9_req_t *req)
>         return 1;
>  }
>
> -/* A request has been fully flushed without a reply.
> - * That means we have posted one buffer in excess.
> - */
> -static int rdma_cancelled(struct p9_client *client, struct p9_req_t *req)
> -{
> -       struct p9_trans_rdma *rdma = client->trans;
> -
> -       atomic_inc(&rdma->excess_rc);
> -       return 0;
> -}
> -
>  /**
>   * trans_create_rdma - Transport method for creating atransport instance
>   * @client: client instance

Hi,

This is wrong.

Please check http://comments.gmane.org/gmane.linux.network/276261.

thanks,
Daniel.
