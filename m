Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbaKUPBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 10:01:30 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37056 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaKUPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 10:01:28 -0500
Message-ID: <1416582085.8629.98.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [RFC] situation with csum_and_copy_... API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>
Date: Fri, 21 Nov 2014 07:01:25 -0800
In-Reply-To: <20141121084956.GT7996@ZenIV.linux.org.uk>
References: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
	 <20141119.161744.1661940121298888832.davem@davemloft.net>
	 <20141119213006.GE7996@ZenIV.linux.org.uk>
	 <20141119.165340.2162829993279387495.davem@davemloft.net>
	 <20141120214753.GR7996@ZenIV.linux.org.uk>
	 <1416520542.8629.46.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141120222506.GS7996@ZenIV.linux.org.uk>
	 <1416524035.8629.54.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141121084956.GT7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 08:49 +0000, Al Viro wrote:

> Another thing is tcp_sendmsg_fastopen() and tcp_send_rcvq().  The latter
> should just use copy_from_iter() instead of memcpy_from_iovec(), the former
> is dealt with by making tcp_send_syn_data() use the same copy_from_iter()
> instead of memcpy_from_iovecend().

Well, another problem I already mentioned is that tcp_send_rcvq() does a
single alloc_skb() with @size directly coming from user space. This
certainly can try allocation of dozen of Megabytes.

Not good.



