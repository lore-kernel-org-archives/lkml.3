Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaCXTOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 15:14:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43379 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaCXTOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 15:14:20 -0400
Date: Mon, 24 Mar 2014 15:14:17 -0400 (EDT)
Message-Id: <20140324.151417.474668383309974516.davem@davemloft.net>
To: asuka.com@163.com
Cc: xeb@mail.ru, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: gre: Fix null pointer dereference in
 gre_cisco_err()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395646471-637-1-git-send-email-asuka.com@163.com>
References: <1395646471-637-1-git-send-email-asuka.com@163.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Mar 2014 12:14:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Zhang <asuka.com@163.com>
Date: Mon, 24 Mar 2014 15:34:31 +0800

> When use the gre vport, openvswitch register a gre_cisco_protocol but
> does not supply a err_handler with it. The gre_cisco_err() call the
> err_handler without existence check, cause the kernel crash.
> 
> This patch base on v3.14-rc7. But the bug affect all kernel newer than
> 3.11!
> 
> Signed-off-by: Wei Zhang <asuka.com@163.com>

Rather, openvswitch should provide an appropriate ->err_handler() that
returns PACKET_RCVD or PACKET_REJECT.

I'm not applying this patch.
