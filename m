Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaLGNll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 08:41:41 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33100 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487AbaLGNlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 08:41:39 -0500
X-Sasl-enc: xeKHzJua5epgYv6i1tg28U/eh4PPMOMv4ZfY0EoIbpWn 1417959698
Message-ID: <1417959696.17658.37.camel@localhost>
Subject: Re: Where exactly will arch_fast_hash be used
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: George Spelvin <linux@horizon.com>
Cc: dborkman@redhat.com, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tgraf@suug.ch
Date: Sun, 07 Dec 2014 14:41:36 +0100
In-Reply-To: <20141207133056.25209.qmail@ns.horizon.com>
References: <20141207133056.25209.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On So, 2014-12-07 at 08:30 -0500, George Spelvin wrote:
> Thanks for the encouragement!
> 
> > Please consider xfs, too.
> > AFAIK xfs doesn't seed their hashing so far and the hashing function is
> > pretty weak. One example:
> > http://marc.info/?l=linux-xfs&m=139590613002926&w=2
> 
> Is that something that *can* be changed without breaking the
> disk format?  SipHash is explicitly *not* designed to be secure as
> an unkeyed hash in the way that SHA-type algorithms are.

I did some research and it looked like it would need a change to the
disk format but it should be doable by incrementing the super block
version, so at least newly created filesystem would benefit from it.

> What it's designed to do is provide second preimage resistance
> of its output, or a function (like modular reduction) of its output,
> against an attacker who doesn't know the secret seed.
> 
> > Ack. If we want to use it in the networking stack we should be able to
> > use it without a dependency to the crypto framework.
> 
> Already understood.  My big question is whether a single function call
> is okay or we need something inlinable.

Like md5_transfrom, I think a non-inline function would be just fine.
Otherwise kernel code size would increase. Most hash users in the
network stack mostly deal with less bytes of input than one round needs.

Bye,
Hannes


