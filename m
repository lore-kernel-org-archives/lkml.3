Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaKUTrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:47:16 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38069 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaKUTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:47:13 -0500
Date: Fri, 21 Nov 2014 14:47:10 -0500 (EST)
Message-Id: <20141121.144710.1431540256452223326.davem@davemloft.net>
To: joestringer@nicira.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pshelar@nicira.com,
        dev@openvswitch.org
Subject: Re: [PATCHv3 net] openvswitch: Don't validate IPv6 label masks.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416434089-47062-1-git-send-email-joestringer@nicira.com>
References: <1416434089-47062-1-git-send-email-joestringer@nicira.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 11:47:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Stringer <joestringer@nicira.com>
Date: Wed, 19 Nov 2014 13:54:49 -0800

> When userspace doesn't provide a mask, OVS datapath generates a fully
> unwildcarded mask for the flow by copying the flow and setting all bits
> in all fields. For IPv6 label, this creates a mask that matches on the
> upper 12 bits, causing the following error:
> 
> openvswitch: netlink: Invalid IPv6 flow label value (value=ffffffff, max=fffff)
> 
> This patch ignores the label validation check for masks, avoiding this
> error.
> 
> Signed-off-by: Joe Stringer <joestringer@nicira.com>
> ---
> v3: Alternative approach.
>     Was "openvswitch: Fix mask generation for IPv6 labels."
> v2: OR lower 20 bits (upper 12 bits remain from earlier memdup)

Applied.
