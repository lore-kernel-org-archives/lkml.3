Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaFPPp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:45:56 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37141 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbaFPPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:45:54 -0400
Message-ID: <539F112F.7030303@linux.com>
Date: Mon, 16 Jun 2014 17:45:51 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nick Krause <xerofoify@gmail.com>,
        Steve Wise <swise@opengridcomputing.com>
CC: swise@chelsio.com, roland@kernel.org, sean.hefty@intel.com,
        hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4]Checks for Null value in function *get_skub
References: <1402932328-3732-1-git-send-email-xerofoify@gmail.com>	<539F0DAF.1020802@opengridcomputing.com> <CAPDOMVjd9J=Kz4d88==UsbfjH13mhGzzmbc2NnxSOfqJs_aGpQ@mail.gmail.com>
In-Reply-To: <CAPDOMVjd9J=Kz4d88==UsbfjH13mhGzzmbc2NnxSOfqJs_aGpQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 05:37 PM, Nick Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>   drivers/infiniband/hw/cxgb4/
> cm.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index f9477e2..2d56983 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -340,15 +340,13 @@ static int status2errno(int status)
>    */
>   static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>   {
>   if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>                  skb_trim(skb, 0);
>                  skb_get(skb);
>                  skb_reset_transport_header(skb);
>          } else {
> +               if (skb)
> /* NULL is ignored */.
> +                       kfree_skb (skb);
>                  skb = alloc_skb(len, gfp);
>          }
>          t4_set_arp_err_handler(skb, NULL, NULL);

This patch is severely whitespace damaged. Can you fix your MUA
or try to use git-send-email?

The changelog as well is of low quality. Maybe something like this:

infiniband: cxgb4: fix memory skb memory leak

... would be better.

Also, this fails the build, due to the extra dot character after
the comment. :-(

Thanks,
     Levente Kurusa.
