Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaDNRkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:40:16 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43257 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbaDNRkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:40:06 -0400
Message-ID: <1397497204.4222.28.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [BUG] A panic caused by null pointer dereference aftering
 updating to
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: nasa4836@gmail.com, jchapman@katalix.com, edumazet@google.com,
        joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 14 Apr 2014 10:40:04 -0700
In-Reply-To: <20140414.133417.308357592624654107.davem@davemloft.net>
References: <534BFC69.6080209@katalix.com>
	 <CAHz2CGVVx3Fi5Vy0dr7z5r2yerbg9cjux61NM0fVeMAtK_Wf9Q@mail.gmail.com>
	 <1397495549.4222.26.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140414.133417.308357592624654107.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 13:34 -0400, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 14 Apr 2014 10:12:29 -0700
> 
> > Hmm, it seems commit 31c70d5956fc l2tp: keep original skb ownership
> > is the problem.
> > 
> > ip_queue_xmit() assumes the socket attached to skb is an inet socket.
> 
> This is similar to the "send over AF_PACKET" issue we were discussing
> the other week.
> 
> It seems we need a real resolution to this issue.
> 
> To recap:
> 
> 1) We want to charge memory to the top-level socket.
> 
> 2) However during encapsulations etc. we can end up in IP stack
>    which expects only IP sockets to be attached to skb->sk
> 
> I suspect that in the short term we may have to bit the bullet and
> compromise #2, and do flow control via the tunnel's socket.

Or add a sk parameter to ip_queue_xmit(), to break the assumption "sk =
skb->sk", which happened to be generally true, but is ambiguous for IP
tunnels.



