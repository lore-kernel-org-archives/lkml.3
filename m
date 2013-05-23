Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab3EWLyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:54:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155Ab3EWLyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:54:01 -0400
Date: Thu, 23 May 2013 14:54:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next RFC 2/8] macvtap: return -EBADFD when TUNGETIFF fails
Message-ID: <20130523115423.GF17993@redhat.com>
References: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
 <1369278753-2533-3-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369278753-2533-3-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:12:27AM +0800, Jason Wang wrote:
> Tuntap return -EBADFD when TUNGETIFF fails, we should return the same value.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Can you add some more comments on why this matters?
Any userspace that cares will have to handle both, right?

> ---
>  drivers/net/macvtap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 59e9605..ce1c72a 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -928,7 +928,7 @@ static long macvtap_ioctl(struct file *file, unsigned int cmd,
>  		rcu_read_unlock_bh();
>  
>  		if (!vlan)
> -			return -ENOLINK;
> +			return -EBADFD;
>  
>  		ret = 0;
>  		if (copy_to_user(&ifr->ifr_name, vlan->dev->name, IFNAMSIZ) ||
> -- 
> 1.7.1
