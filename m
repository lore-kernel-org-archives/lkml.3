Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaFPPKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:10:33 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:63085 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaFPPKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:10:31 -0400
MIME-Version: 1.0
In-Reply-To: <1402931337-3543-1-git-send-email-xerofoify@gmail.com>
References: <1402931337-3543-1-git-send-email-xerofoify@gmail.com>
Date: Mon, 16 Jun 2014 11:10:30 -0400
Message-ID: <CAPDOMVi9V6ezvDWTKChv5afb_0M=ch0wog2b699fuOOe=sGVXA@mail.gmail.com>
Subject: Re: [PATCHv3]Checks for Null value in function *get_skub
From: Nick Krause <xerofoify@gmail.com>
To: swise@chelsio.com
Cc: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug is open here https://bugzilla.kernel.org/show_bug.cgi?id=44631.
I would recommend closing it now as I seem to have fixed it.
Cheers Nick

On Mon, Jun 16, 2014 at 11:08 AM, Nicholas Krause <xerofoify@gmail.com> wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index f9477e2..2d56983 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -340,15 +340,13 @@ static int status2errno(int status)
>   */
>  static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>  {
>  if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>                 skb_trim(skb, 0);
>                 skb_get(skb);
>                 skb_reset_transport_header(skb);
>         } else {
> +               if (skb)
> +                       kfree (skb);
>                 skb = alloc_skb(len, gfp);
>         }
>         t4_set_arp_err_handler(skb, NULL, NULL);
> --
> 1.9.1
>
