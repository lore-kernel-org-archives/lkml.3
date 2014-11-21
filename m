Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbaKUCWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:22:12 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45741 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbaKUCWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:22:10 -0500
Message-ID: <1416536527.8629.74.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] tcp: Restore RFC5961-compliant behavior for SYN packets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Calvin Owens <calvinowens@fb.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>, Eric Dumazet <edumazet@google.com>,
        kernel-team@fb.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Nov 2014 18:22:07 -0800
In-Reply-To: <20141121014727.GA1536781@mail.thefacebook.com>
References: <1416524993-26228-1-git-send-email-calvinowens@fb.com>
	 <1416526940.8629.62.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141121014727.GA1536781@mail.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-20 at 17:47 -0800, Calvin Owens wrote:

> That's actually not what led to finding this, but it's a good point. :)
> 
> What if the challenge-ACK counter were decremented in tcp_validate_incoming()
> when a valid RST packet is seen? That would allow legitimate remote
> hosts to reestablish connections without being ratelimited, and still
> prevent a malicious host from guessing sequence numbers.
> 
> There would need to be a way to tell if a challenge ACK had in fact been
> sent and only decrement in that case, since otherwise a local attacker
> could establish and immediately reset lots of connections to keep the
> counter below the ratelimit threshold and guess sequence numbers.
> 
> Simply adding a flag to struct tcp_sock would work: just set the flag
> whenever a challenge ACK is sent, and clear it and decrement the counter
> only if it is set when a valid RST packet is seen.

Seems tricky, a Challenge ACK do not necessarily gives an RST.

Anyway this certainly can wait, as we already have a sysctl to
eventually work around the issue.

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks !


