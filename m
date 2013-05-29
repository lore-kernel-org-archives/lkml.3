Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094Ab3E2HWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:22:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44084 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935045Ab3E2HWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:22:11 -0400
Date: Wed, 29 May 2013 00:22:08 -0700 (PDT)
Message-Id: <20130529.002208.1948977466672387293.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [PATCH] tuntap: forbid changing mq flag for persistent device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369801931-6856-1-git-send-email-jasowang@redhat.com>
References: <1369801931-6856-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Wed, 29 May 2013 12:32:11 +0800

> We currently allow changing the mq flag (IFF_MULTI_QUEUE) for a persistent
> device. This will result a mismatch between the number the queues in netdev and
> tuntap. This is because we only allocate a 1q netdevice when IFF_MULTI_QUEUE was
> not specified, so when we set the IFF_MULTI_QUEUE and try to attach more queues
> later, netif_set_real_num_tx_queues() may fail which result a single queue
> netdevice with multiple sockets attached.
> 
> Solve this by disallowing changing the mq flag for persistent device.
> 
> Bug was introduced by commit edfb6a148ce62e5e19354a1dcd9a34e00815c2a1
> (tuntap: reduce memory using of queues).
> 
> Reported-by: Sriram Narasimhan <sriram.narasimhan@hp.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks Jason.
