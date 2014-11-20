Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbaKTVzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:55:48 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:55973 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbaKTVzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:55:45 -0500
Message-ID: <1416520542.8629.46.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [RFC] situation with csum_and_copy_... API
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>
Date: Thu, 20 Nov 2014 13:55:42 -0800
In-Reply-To: <20141120214753.GR7996@ZenIV.linux.org.uk>
References: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
	 <20141119.161744.1661940121298888832.davem@davemloft.net>
	 <20141119213006.GE7996@ZenIV.linux.org.uk>
	 <20141119.165340.2162829993279387495.davem@davemloft.net>
	 <20141120214753.GR7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-20 at 21:47 +0000, Al Viro wrote:

> As far as I can see, these retries on the send side are simply broken -
> normally we are talking to TCP sockets there and tcp_sendmsg() does *not*
> modify iovec in normal case. 

Arg... I sent this morning something doing this (against net-next tree)

Is it a problem ?

Or can we consider FASTOPEN being not normal case ? ;)

https://patchwork.ozlabs.org/patch/412776/



