Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaAQBhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:37:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55908 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaAQBhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:37:38 -0500
Date: Thu, 16 Jan 2014 17:37:37 -0800 (PST)
Message-Id: <20140116.173737.429918297549548812.davem@davemloft.net>
To: jasowang@redhat.com
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com
Subject: Re: [PATCH net-next] virtio-net: drop rq->max and rq->num
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389854724-48411-1-git-send-email-jasowang@redhat.com>
References: <1389854724-48411-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 16 Jan 2014 14:45:24 +0800

> It looks like there's no need for those two fields:
> 
> - Unless there's a failure for the first refill try, rq->max should be always
>   equal to the vring size.
> - rq->num is only used to determine the condition that we need to do the refill,
>   we could check vq->num_free instead.
> - rq->num was required to be increased or decreased explicitly after each
>   get/put which results a bad API.
> 
> So this patch removes them both to make the code simpler.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Applied, thanks.
