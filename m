Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaBCVF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:05:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35610 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaBCVFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:05:54 -0500
Date: Mon, 03 Feb 2014 13:03:09 -0800 (PST)
Message-Id: <20140203.130309.1340651554312620948.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: tt.rantala@gmail.com, netdev@vger.kernel.org, davej@redhat.com,
        trinity@vger.kernel.org, linux-kernel@vger.kernel.org,
        therbert@google.com, maze@google.com
Subject: Re: [PATCH] ip_tunnel: fix panic in ip_tunnel_xmit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1391460734.28432.111.camel@edumazet-glaptop2.roam.corp.google.com>
References: <CA+ydwtpmFbhkck9z8G7tfHQZW+4rWSepQMgPURqVCwrZ77v2bA@mail.gmail.com>
	<CA+ydwto5CTDSED=pZ_DfAZyh6Jx7xKJafRuDFUtV4ZZCb70ULA@mail.gmail.com>
	<1391460734.28432.111.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 03 Feb 2014 12:52:14 -0800

> From: Eric Dumazet <edumazet@google.com>
> 
> Setting rt variable to NULL at the beginning of ip_tunnel_xmit()
> missed possible use of this variable as a scratch value.
> 
> Also fixes a possible dst leak in tunnel_dst_check() :
> If we had to call tunnel_dst_reset(), we forgot to
> release the reference on dst.
> 
> Merges tunnel_dst_get()/tunnel_dst_check() into
> a single tunnel_rtable_get() function for clarity.
> 
> Many thanks to Tommi for his report and tests.
> 
> Fixes: 7d442fab0a67 ("ipv4: Cache dst in tunnels)"
> Reported-by: Tommi Rantala <tt.rantala@gmail.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Tested-by: Tommi Rantala <tt.rantala@gmail.com>
> Cc: Tom Herbert <therbert@google.com>
> Cc: Maciej ¯enczykowski <maze@google.com>

Applied, thanks Eric.
