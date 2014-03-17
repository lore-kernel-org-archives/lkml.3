Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaCQUUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:20:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42537 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaCQUT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:19:58 -0400
Date: Mon, 17 Mar 2014 16:19:55 -0400 (EDT)
Message-Id: <20140317.161955.776021754942208577.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v2,1/1] hyperv: Add support for virtual
 Receive Side Scaling (vRSS)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394903887-30421-2-git-send-email-haiyangz@microsoft.com>
References: <1394903887-30421-1-git-send-email-haiyangz@microsoft.com>
	<1394903887-30421-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Mar 2014 13:19:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Sat, 15 Mar 2014 10:18:07 -0700

> -		if (netif_queue_stopped(ndev) && !net_device->start_remove &&
> -			(hv_ringbuf_avail_percent(&device->channel->outbound)
> -			> RING_AVAIL_PERCENT_HIWATER ||
> -			num_outstanding_sends < 1))
> -				netif_wake_queue(ndev);
> +		if (netif_tx_queue_stopped(netdev_get_tx_queue(ndev, q_idx))
> +			&& !net_device->start_remove &&
> +			(hv_ringbuf_avail_percent(&channel->outbound)
> +			> RING_AVAIL_PERCENT_HIWATER || queue_sends < 1))
> +				netif_tx_wake_queue(netdev_get_tx_queue(
> +						    ndev, q_idx));

This is not indented properly, make it:

	if (A && B &&
	    (C >
             D || E < 1))

Never put operators at the beginning of a conditional line, always at
the end.
