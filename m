Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaJSSul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 14:50:41 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52198 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaJSSuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 14:50:39 -0400
Message-ID: <1413744637.27176.40.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] ipv6: tcp_v6_iff: fix compilation error on CONFIG_IPV6=n
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Manfred Schlaegl <manfred.schlaegl@gmx.at>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manfred Schlaegl <manfred.schlaegl@ginzinger.com>
Date: Sun, 19 Oct 2014 11:50:37 -0700
In-Reply-To: <5443FD47.7040003@gmx.at>
References: <5443FD47.7040003@gmx.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-19 at 20:04 +0200, Manfred Schlaegl wrote:
> If CONFIG_IPV6=n, then h6 in struct tcp_skb_cb.header is missing which
> leads to compilation-errors on tcp_v6_iff like:
> 
> In file included from net/core/sock.c:140:0:
> include/net/tcp.h: In function ‘tcp_v6_iif’:
> include/net/tcp.h:738:32: error: ‘union <anonymous>’ has no member named
> ‘h6’
> 
> This fix solves the problem by removing tcp_v6_iif, in case of
> CONFIG_IPV6=n.
> 
> Signed-off-by: Manfred Schlaegl <manfred.schlaegl@gmx.at>
> ---

Yes, this was fixed yesterday, thanks.

http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=815afe1785da727ee48cd8e63ac4a3ec6c7459b3


