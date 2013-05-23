Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab3EWPLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:11:06 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:60315 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab3EWPLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:11:04 -0400
Message-ID: <519E318B.2010804@cogentembedded.com>
Date: Thu, 23 May 2013 19:11:07 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next RFC 3/8] macvtap: introduce macvtap_get_vlan()
References: <1369278753-2533-1-git-send-email-jasowang@redhat.com> <1369278753-2533-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1369278753-2533-4-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-05-2013 7:12, Jason Wang wrote:

> Factor out the device holding logic to a macvtap_get_vlan(), this will be also
> used by multiqueue API.

> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/net/macvtap.c |   26 +++++++++++++++++++-------
>   1 files changed, 19 insertions(+), 7 deletions(-)

> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index ce1c72a..a36e49e 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -890,6 +890,23 @@ out:
>   	return ret;
>   }
>
> +static struct macvlan_dev *macvtap_get_vlan(struct macvtap_queue *q)
> +{
> +	struct macvlan_dev *vlan;

    Empty line wouldn't hurt here, after declaration.

> +	rcu_read_lock_bh();
> +	vlan = rcu_dereference_bh(q->vlan);
> +	if (vlan)
> +		dev_hold(vlan->dev);
> +	rcu_read_unlock_bh();
> +
> +	return vlan;
> +}
[...]

WBR, Sergei

