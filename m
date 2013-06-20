Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab3FTEzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 00:55:35 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59612 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3FTEze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 00:55:34 -0400
Message-ID: <1371704129.3252.356.camel@edumazet-glaptop>
Subject: Re: [PATCH] net bridge: add null pointer check, fix panic
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xiaoming gao <gxm.linux.kernel@gmail.com>
Cc: stephen@networkplumber.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Jun 2013 21:55:29 -0700
In-Reply-To: <51C2721B.9050603@gmail.com>
References: <51C2710D.2060405@gmail.com> <51C2721B.9050603@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 11:08 +0800, xiaoming gao wrote:
> From: newtongao <newtongao@tencent.com>
> Date: Wed, 19 Jun 2013 14:58:33 +0800
> Subject: [PATCH] net bridge: add null pointer check,fix panic
> 
> in kernel 3.0, br_port_get_rcu() may return NULL when network interface be deleting from bridge,
> but in function br_handle_frame and br_handle_local_finish, the pointer didn't be checked before using,
> so all br_port_get_rcu callers must do null check,or there occurs the null pointer panic.
> 
> kernel 3.4 also has this bug,i have verified.
> mainline kernel still did not  check br_port_get_rcu()'s NULL pointer, but i have not tested it yet.

Please check current version before sending a patch.

This was most probably fixed in commit 00cfec37484761a44
("net: add a synchronize_net() in netdev_rx_handler_unregister()")

Thanks


