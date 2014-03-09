Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaCIXJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 19:09:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36923 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaCIXJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 19:09:42 -0400
Date: Sun, 09 Mar 2014 19:09:41 -0400 (EDT)
Message-Id: <20140309.190941.472588800498066811.davem@davemloft.net>
To: guz.fnst@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netlink: switch net_ns only if net is not init_net
From: David Miller <davem@davemloft.net>
In-Reply-To: <5319A3C2.8080001@cn.fujitsu.com>
References: <5319A3C2.8080001@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Mar 2014 16:09:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Fri, 07 Mar 2014 18:47:30 +0800

> Many netlink users create netlink sock in the init_net, and the
> switching nes_ns(init_net-->net) is needless in this case. So here
> we add a pre-check to avoid this.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

This check is more appropriately placed into sk_change_net() itself.
