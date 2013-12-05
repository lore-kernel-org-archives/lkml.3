Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3LEVXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 16:23:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58026 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3LEVXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:23:35 -0500
Date: Thu, 05 Dec 2013 16:23:33 -0500 (EST)
Message-Id: <20131205.162333.1525865133149454763.davem@davemloft.net>
To: ydroneaud@opteya.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2] net: handle error more gracefully in socketpair()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385979146-13825-1-git-send-email-ydroneaud@opteya.com>
References: <1385977019-12282-1-git-send-email-ydroneaud@opteya.com>
	<1385979146-13825-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Dec 2013 13:23:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Droneaud <ydroneaud@opteya.com>
Date: Mon,  2 Dec 2013 11:12:26 +0100

> socketpair() error paths can be simplified to not call
> heavy-weight sys_close().
> 
> This patch makes socketpair() use of error paths which do not
> rely on heavy-weight call to sys_lose(): it's better to try
> to push the file descriptor to userspace before installing
> the socket file to the file descriptor, so that errors are
> catched earlier and being easier to handle.
> 
> Three distinct error paths are needed since calling fput()
> on file structure returned by sock_alloc_file() will
> implicitly call sock_release() on the associated socket
> structure.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> Link: http://marc.info/?i=1385977019-12282-1-git-send-email-ydroneaud@opteya.com

I know that sys_close() is expensive, _but_ erroring out on
the put_user() is extremely rare and logically it makes
a ton more sense to fully install a file descriptor before
writing it's numeric value into userspace.

Sorry, I think the current code is fine and I'm not going
to apply this, thanks.
