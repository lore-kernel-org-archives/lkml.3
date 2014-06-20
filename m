Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaFTEGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:06:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46325 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaFTEGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:06:40 -0400
Date: Thu, 19 Jun 2014 21:06:37 -0700 (PDT)
Message-Id: <20140619.210637.1702701955085552032.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, rdunlap@infradead.org, sfr@canb.auug.org.au,
        hjk@hansjkoch.de, gregkh@linuxfoundation.org,
        stephen@networkplumber.org, sean.hefty@intel.com, fx.lebail@yahoo.com,
        jasowang@redhat.com, hannes@stressinduktion.org,
        wuzhy@linux.vnet.ibm.com, nab@linux-iscsi.org, netdev@vger.kernel.org
Subject: Re: [PATCH] iovec: move memcpy_from/toiovecend to lib/iovec.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403201568-22828-1-git-send-email-mst@redhat.com>
References: <1403201568-22828-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Jun 2014 21:06:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 19 Jun 2014 21:22:56 +0300

> ERROR: "memcpy_fromiovecend" [drivers/vhost/vhost_scsi.ko] undefined!
> 
> commit 9f977ef7b671f6169eca78bf40f230fe84b7c7e5
>     vhost-scsi: Include prot_bytes into expected data transfer length
> in target-pending makes drivers/vhost/scsi.c call memcpy_fromiovecend().
> This function is not available when CONFIG_NET is not enabled.
> 
> socket.h already includes uio.h, so no callers need updating.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> David, could you please ack merging this through
> target-pending to avoid dependency issues?

Yep, this looks fine:

Signed-off-by: David S. Miller <davem@davemloft.net>
