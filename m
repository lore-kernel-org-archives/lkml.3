Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbaANWbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:31:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:52747 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaANWbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:31:34 -0500
Date: Tue, 14 Jan 2014 14:31:33 -0800 (PST)
Message-Id: <20140114.143133.1863157816134006560.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next] hyperv: Add support for physically
 discontinuous receive buffer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389306287-20057-1-git-send-email-haiyangz@microsoft.com>
References: <1389306287-20057-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu,  9 Jan 2014 14:24:47 -0800

> This will allow us to use bigger receive buffer, and prevent allocation failure
> due to fragmented memory.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Not until you start using paged SKBs in netvsc_recv_callback.

Whatever fragmention you think you're avoiding in the hyperv layer,
you're still going to get from the:

	skb = netdev_alloc_skb_ip_align(net, packet->total_data_buflen);

call there.

This change makes no sense in isolation, therefore I'm not applying it
until you also include the appropriate changes to avoid the same
exact fragmentation issue in netvsc_drv.c as stated above.
