Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaG1UhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:37:12 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:38668 "HELO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751915AbaG1UhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:37:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140727070746.GA4825@himangi-Dell>
References: <20140727070746.GA4825@himangi-Dell>
Date: Mon, 28 Jul 2014 13:37:09 -0700
Message-ID: <CALnjE+pjdWLCKya6FeqfZqYra=p=vjDN2nywrdTWuRErGmpu9w@mail.gmail.com>
Subject: Re: [PATCH] openvswitch: Use IS_ERR_OR_NULL
From: Pravin Shelar <pshelar@nicira.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 12:07 AM, Himangi Saraogi <himangi774@gmail.com> wrote:
> This patch introduces the use of the macro IS_ERR_OR_NULL in place of
> tests for NULL and IS_ERR.
>
> The following Coccinelle semantic patch was used for making the change:
>
> @@
> expression e;
> @@
>
> - e == NULL || IS_ERR(e)
> + IS_ERR_OR_NULL(e)
>  || ...
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Looks good.
Acked-by: Pravin B Shelar <pshelar@nicira.com>

> ---
>  net/openvswitch/datapath.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 20f59b6..e3b3c21 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -780,7 +780,7 @@ static struct sk_buff *ovs_flow_cmd_build_info(const struct sw_flow *flow,
>
>         skb = ovs_flow_cmd_alloc_info(ovsl_dereference(flow->sf_acts), info,
>                                       always);
> -       if (!skb || IS_ERR(skb))
> +       if (IS_ERR_OR_NULL(skb))
>                 return skb;
>
>         retval = ovs_flow_cmd_fill_info(flow, dp_ifindex, skb,
> --
> 1.9.1
>
