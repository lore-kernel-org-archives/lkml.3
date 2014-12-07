Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaLGFUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 00:20:43 -0500
Received: from ns.horizon.com ([71.41.210.147]:37915 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750721AbaLGFUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 00:20:43 -0500
Date: 7 Dec 2014 00:20:41 -0500
Message-ID: <20141207052041.20498.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: herbert@gondor.apana.org.au
Subject: Re: Where exactly will arch_fast_hash be used
Cc: dborkman@redhat.com, hannes@stressinduktion.org, linux@horizon.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tgraf@suug.ch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you want DoS-resistant hash tables, I'm working on adding SipHash
to the kernel.

This is a keyed pseudo-random function designed specifically for that
application.  I am starting with ext4 directory hashes, and then intended
to expand to secure sequence numbers (since it's far faster than MD5).

(I'm trying to figure out a good interface, since the crypto API
is a bit heavy for something to heavily optimized.)

But one comment caught my eye:
> Even if security wasn't an issue, straight CRC32 has really poor
> lower-order bit distribution, which makes it a terrible choice for
> a hash table that simply uses the lower-order bits.

Er... huh?  That's the first time I've heard that claim, and while I'm not
Philip Koopman or Guy Castagnoli, I thought I understood CRCs pretty well.

CRCs generally mix bits pretty well.  The sparse 16-bit CRCs chosen
for implementation simplicity had some limitations, but the Castagnoli
polynomial is quite dense.

And their mathematical symmetry means that the low bits really shouldn't
be any different from any other bits.  But if it is an issue, it's just
as easy work to shift down the correct number of high bits rather than
using the low.

Can you point me to a source for that statement?
