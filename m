Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaHNV3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:29:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbaHNV3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:29:04 -0400
Date: Thu, 14 Aug 2014 14:28:56 -0700 (PDT)
Message-Id: <20140814.142856.1220870703473741209.davem@redhat.com>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v2] hyperv: Increase the buffer length for
 netvsc_channel_cb()
From: David Miller <davem@redhat.com>
In-Reply-To: <1407953024-35191-1-git-send-email-haiyangz@microsoft.com>
References: <1407953024-35191-1-git-send-email-haiyangz@microsoft.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Wed, 13 Aug 2014 18:03:44 +0000

> When the buffer is too small for a packet from VMBus, a bigger buffer will be
> allocated in netvsc_channel_cb() and retry reading the packet from VMBus.
> Increasing this buffer size will reduce the retry overhead.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
...
> -	net_device = kzalloc(sizeof(struct netvsc_device), GFP_KERNEL);
> +	net_device = vzalloc(sizeof(*net_device));

This isn't what I suggested that you do.

I said that the buffer inside of netvsc_device should be made an
indirect pointer and thus allocated seperately.

Thus you're still kzalloc() net_device, but net_device->cb_buffer
becomes "unsigned char *" and another allocation is made for it.
