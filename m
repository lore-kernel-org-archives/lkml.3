Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161925AbaKNUj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:39:26 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:58476 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754377AbaKNUjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:39:24 -0500
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2014 15:39:24 EST
MIME-Version: 1.0
In-Reply-To: <1415989978-28559-1-git-send-email-fabf@skynet.be>
References: <1415989978-28559-1-git-send-email-fabf@skynet.be>
Date: Fri, 14 Nov 2014 12:34:06 -0800
Message-ID: <CALnjE+p1GaoCnvk_KVZu--Gmf=CK=TbmWjbpN=LqQk==dRCJMg@mail.gmail.com>
Subject: Re: [PATCH 1/1 net-next] openvswitch: use PTR_ERR_OR_ZERO
From: Pravin Shelar <pshelar@nicira.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 10:32 AM, Fabian Frederick <fabf@skynet.be> wrote:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Pravin B Shelar <pshelar@nicira.com>

> ---
>  net/openvswitch/flow_netlink.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
> index c0d066d..c8fccdd 100644
> --- a/net/openvswitch/flow_netlink.c
> +++ b/net/openvswitch/flow_netlink.c
> @@ -1425,10 +1425,8 @@ static int add_action(struct sw_flow_actions **sfa, int attrtype,
>         struct nlattr *a;
>
>         a = __add_action(sfa, attrtype, data, len, log);
> -       if (IS_ERR(a))
> -               return PTR_ERR(a);
>
> -       return 0;
> +       return PTR_ERR_OR_ZERO(a);
>  }
>
>  static inline int add_nested_action_start(struct sw_flow_actions **sfa,
> --
> 1.9.3
>
