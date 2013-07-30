Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab3G3X1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 19:27:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43374 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab3G3X1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 19:27:15 -0400
Date: Tue, 30 Jul 2013 16:27:14 -0700 (PDT)
Message-Id: <20130730.162714.310395724208648975.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: sage@inktank.com, ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] libceph: fix deadlock in ceph_build_auth()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375066688-12367-1-git-send-email-khoroshilov@ispras.ru>
References: <1375066688-12367-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 16:27:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Mon, 29 Jul 2013 06:58:08 +0400

> ceph_build_auth() locks ac->mutex and then calls ceph_auth_build_hello()
> that locks the same mutex, i.e. bring itself to deadlock.
> 
> The patch moves actual code from ceph_auth_build_hello() to
> ceph_build_hello_auth_request() that should be called with ac->mutex held
> and makes ceph_build_auth() calling it.
> ceph_auth_build_hello() is left with untouched semantics as a wrapper
> around ceph_build_hello_auth_request().
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

I'm assume the ceph developers will pick this up, thanks.
