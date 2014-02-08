Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaBHUHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:07:12 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:35889 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaBHUHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:07:08 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 8 Feb 2014 12:07:00 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Jiri Pirko <jiri@resnulli.us>, Pravin B Shelar <pshelar@nicira.com>,
        Cong Wang <amwang@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 04/13] net: Mark functions as static in core/dev.c
Message-ID: <20140208200700.GD20885@leaf>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
 <ccd9586270a8ebb87aeadc10feff52857b7f907c.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ccd9586270a8ebb87aeadc10feff52857b7f907c.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 01:23:45AM +0530, Rashika Kheria wrote:
> Mark functions as static in core/dev.c because they are not used outside
> this file.
> 
> This eliminates the following warning in core/dev.c:
> net/core/dev.c:2806:5: warning: no previous prototype for ‘__dev_queue_xmit’ [-Wmissing-prototypes]
> net/core/dev.c:4640:5: warning: no previous prototype for ‘netdev_adjacent_sysfs_add’ [-Wmissing-prototypes]
> net/core/dev.c:4650:6: warning: no previous prototype for ‘netdev_adjacent_sysfs_del’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  net/core/dev.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 3721db7..4ad1b78 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2803,7 +2803,7 @@ EXPORT_SYMBOL(dev_loopback_xmit);
>   *      the BH enable code must have IRQs enabled so that it will not deadlock.
>   *          --BLG
>   */
> -int __dev_queue_xmit(struct sk_buff *skb, void *accel_priv)
> +static int __dev_queue_xmit(struct sk_buff *skb, void *accel_priv)
>  {
>  	struct net_device *dev = skb->dev;
>  	struct netdev_queue *txq;
> @@ -4637,7 +4637,7 @@ struct net_device *netdev_master_upper_dev_get_rcu(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(netdev_master_upper_dev_get_rcu);
>  
> -int netdev_adjacent_sysfs_add(struct net_device *dev,
> +static int netdev_adjacent_sysfs_add(struct net_device *dev,
>  			      struct net_device *adj_dev,
>  			      struct list_head *dev_list)
>  {
> @@ -4647,7 +4647,7 @@ int netdev_adjacent_sysfs_add(struct net_device *dev,
>  	return sysfs_create_link(&(dev->dev.kobj), &(adj_dev->dev.kobj),
>  				 linkname);
>  }
> -void netdev_adjacent_sysfs_del(struct net_device *dev,
> +static void netdev_adjacent_sysfs_del(struct net_device *dev,
>  			       char *name,
>  			       struct list_head *dev_list)
>  {
> -- 
> 1.7.9.5
> 
