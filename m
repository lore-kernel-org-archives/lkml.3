Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbaKSUTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:19:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38338 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbaKSUTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:19:51 -0500
Date: Wed, 19 Nov 2014 15:19:48 -0500 (EST)
Message-Id: <20141119.151948.1499529626052606712.davem@davemloft.net>
To: joestringer@nicira.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pshelar@nicira.com,
        dev@openvswitch.org
Subject: Re: [PATCH net] openvswitch: Fix mask generation for IPv6 labels.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416336857-61405-1-git-send-email-joestringer@nicira.com>
References: <1416336857-61405-1-git-send-email-joestringer@nicira.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 12:19:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Stringer <joestringer@nicira.com>
Date: Tue, 18 Nov 2014 10:54:17 -0800

> When userspace doesn't provide a mask, OVS datapath generates a fully
> unwildcarded mask for the flow. This is done by taking a copy of the
> flow key, then iterating across its attributes, setting all values to
> 0xff. This works for most attributes, as the length of the netlink
> attribute typically matches the length of the value. However, IPv6
> labels only use the lower 20 bits of the field. This patch makes a
> special case to handle this.
> 
> This fixes the following error seen when installing IPv6 flows without a mask:
> 
> openvswitch: netlink: Invalid IPv6 flow label value (value=ffffffff, max=fffff)
> 
> Signed-off-by: Joe Stringer <joestringer@nicira.com>

Judging by the discussion ongoing about this patch, I am assuming there
will be a new version of this change forthcoming.

Thanks.
