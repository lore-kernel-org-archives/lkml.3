Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaFGRgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 13:36:42 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:57025 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaFGRgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 13:36:40 -0400
Date: Sat, 7 Jun 2014 21:36:35 +0400
From: Dmitry Popov <ixaphire@qrator.net>
To: Dmitry Popov <ixaphire@qrator.net>
Cc: Dmitry Kozlov <xeb@mail.ru>, Cong Wang <cwang@twopensource.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        trivial@kernel.org
Subject: Re: [PATCH] ipip, sit: fix ipv4_{update_pmtu,redirect} calls
Message-Id: <20140607213635.490493e5846e3c81704de67d@qrator.net>
In-Reply-To: <20140607195412.94b079a97a6e1452e539037f@qrator.net>
References: <20140606231921.2ff39106ac54216fd9170fae@qrator.net>
	<CAHA+R7NUVPz47AKCTk7nYBkZXK=93vJOO8f6FTkyU0UkU6Q30Q@mail.gmail.com>
	<20140607195412.94b079a97a6e1452e539037f@qrator.net>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2014 19:54:12 +0400
Dmitry Popov <ixaphire@qrator.net> wrote:

> 3) gre:
> ipgre is a framework for subprotos which doesn't work with tunnel devices by
> itself (see net/ipv4/gre_demux.c:gre_cisco_err). Although it uses 
> skb->dev->ifindex for ipv4_{update_pmtu,redirect} which might be wrong for hosts
> with asymmetric routing, this is not a big deal, because tunnels bound to device 
> will not work with asymmetric routing anyway. So I think it is okay.

Actually, yes, it may not work in case of unbound tunnel and asymmetric routing,
but we'll need to put icmp redirects/frag_needed handling inside 
gre_cisco_protocol->err_handler then, I am not sure if it's worth it.
