Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3GAImM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:42:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab3GAImA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:42:00 -0400
Message-ID: <1372668049.2974.25.camel@cr0>
Subject: Re: [RFC Patch net-next 3/5] inetpeer: use generic union inet_addr
From: Cong Wang <amwang@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org
Date: Mon, 01 Jul 2013 16:40:49 +0800
In-Reply-To: <1372320082.3301.217.camel@edumazet-glaptop>
References: <1372315398-19683-1-git-send-email-amwang@redhat.com>
	 <1372315398-19683-4-git-send-email-amwang@redhat.com>
	 <1372320082.3301.217.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 01:01 -0700, Eric Dumazet wrote:
> On Thu, 2013-06-27 at 14:43 +0800, Cong Wang wrote:
> >  struct inet_peer {
> >  	/* group together avl_left,avl_right,v4daddr to speedup lookups */
> >  	struct inet_peer __rcu	*avl_left, *avl_right;
> > -	struct inetpeer_addr	daddr;
> > +	union inet_addr		daddr;
> 
> Please compare sizeof(struct inetpeer_addr) and sizeof(union inet_addr)
> 
> If I am not mistaken, its 20 bytes instead of 28
> 
> Yes, sockaddr_in6 is a bit bloated...
> 

You are right.

Are you saying that I should rearrange the fields of struct inet_peer in
case of cacheline miss?

Thanks!

