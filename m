Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3GIT4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 15:56:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58946 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3GIT4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 15:56:33 -0400
Date: Tue, 09 Jul 2013 12:56:32 -0700 (PDT)
Message-Id: <20130709.125632.1573031651619706332.davem@davemloft.net>
To: khlebnikov@openvz.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.tarnyagin@lockless.no
Subject: Re: [PATCH] drivers/net: caif: fix wrong rtnl_is_locked() usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130708072304.20622.60798.stgit@zurg>
References: <20130708072304.20622.60798.stgit@zurg>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Mon, 08 Jul 2013 11:23:04 +0400

> rtnl_is_locked() doesn't check who holds this lock, it just tells that it's
> locked right now. if caif::ldisc_close really can be called under rtrnl_lock
> then it should release net device in other context because there is no way
> to grab rtnl_lock without deadlock.
> 
> This patch adds work which releases these devices. Also this patch fixes calling
> dev_close/unregister_netdevice without rtnl_lock from caif_ser_exit().
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

Applied.
