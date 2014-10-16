Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaJPBTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 21:19:35 -0400
Received: from na6sys009bog027.obsmtp.com ([74.125.150.94]:37967 "HELO
	na6sys009bog027.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751348AbaJPBTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 21:19:34 -0400
MIME-Version: 1.0
In-Reply-To: <1413399821-8558-1-git-send-email-fabf@skynet.be>
References: <1413399821-8558-1-git-send-email-fabf@skynet.be>
Date: Wed, 15 Oct 2014 18:11:52 -0700
Message-ID: <CALnjE+ohd=zcCVmBEcaGqyD70uX=DXj-YoKP2pFw5JuncxjiFQ@mail.gmail.com>
Subject: Re: [PATCH 1/1 net-next] openvswitch: use vport instead of p
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

On Wed, Oct 15, 2014 at 12:03 PM, Fabian Frederick <fabf@skynet.be> wrote:
> All functions used struct vport *vport except
> ovs_vport_find_upcall_portid.
>
> This fixes 1 kerneldoc warning
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>


Acked-by: Pravin B Shelar <pshelar@nicira.com>

Thanks.

> ---
>  net/openvswitch/vport.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
> index 53001b0..6015802 100644
> --- a/net/openvswitch/vport.c
> +++ b/net/openvswitch/vport.c
> @@ -408,13 +408,13 @@ int ovs_vport_get_upcall_portids(const struct vport *vport,
>   *
>   * Returns the portid of the target socket.  Must be called with rcu_read_lock.
>   */
> -u32 ovs_vport_find_upcall_portid(const struct vport *p, struct sk_buff *skb)
> +u32 ovs_vport_find_upcall_portid(const struct vport *vport, struct sk_buff *skb)
>  {
>         struct vport_portids *ids;
>         u32 ids_index;
>         u32 hash;
>
> -       ids = rcu_dereference(p->upcall_portids);
> +       ids = rcu_dereference(vport->upcall_portids);
>
>         if (ids->n_ids == 1 && ids->ids[0] == 0)
>                 return 0;
> --
> 1.9.3
>
