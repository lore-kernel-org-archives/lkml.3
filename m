Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbaJNVhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:37:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45009 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaJNVhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:37:19 -0400
Date: Tue, 14 Oct 2014 17:37:17 -0400 (EDT)
Message-Id: <20141014.173717.1412701736631211553.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,v2] hyperv: Add handling of IP header with
 option field in netvsc_set_hash()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413324988-8863-1-git-send-email-haiyangz@microsoft.com>
References: <1413324988-8863-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Oct 2014 14:37:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 14 Oct 2014 15:16:28 -0700

> In case that the IP header has optional field at the end, this patch will
> get the port numbers after that field, and compute the hash.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

Instead of adding hack after hack after hack to your internal header
parser, just use the generic flow dissector we already have in the
kernel to fetch out the values you need.

__skb_flow_get_ports() etc.
