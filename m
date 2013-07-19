Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788Ab3GSQYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:24:22 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45389 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760594Ab3GSQYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:24:21 -0400
Message-ID: <1374251057.26476.17.camel@edumazet-glaptop>
Subject: strange crashes in tcp_poll() via epoll_wait
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 19 Jul 2013 09:24:17 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al

I tried to debug strange crashes in tcp_poll() called from
sys_epoll_wait() -> sock_poll()

The symptom is that sock->sk is NULL and we therefore dereference a NULL
pointer.

It's really rare crashes but still, it would be nice to understand where
is the bug. Presumably latest kernels would crash in sock_poll() because
of the sk_can_busy_loop(sock->sk) call.

We do test sock->sk being NULL in sock_fasync(), but epoll should be
safe because of existing synchronization (epmutex) ?

Any idea?

Thanks !


