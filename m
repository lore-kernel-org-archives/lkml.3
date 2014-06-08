Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaFHMke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:40:34 -0400
Received: from ns.horizon.com ([71.41.210.147]:20764 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751023AbaFHMkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:40:33 -0400
Date: 8 Jun 2014 08:40:31 -0400
Message-ID: <20140608124031.2571.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dborkman@redhat.com, linux@horizon.com
Subject: Re: [PATCH 4/7] lib/random32.c: Use <asm/unaligned.h> instead of hand-rolling it
Cc: davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, shemminger@osdl.org, tytso@mit.edu
In-Reply-To: <53945633.20702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Seems fine by me, since it's random anyway archs might not care
> about the *_le32, though this might yield additional work in some
> cases I presume.

If you think that's okay, sure.  I kept it consistent to get byte-for-byte
identical results.

If variations in that are allowed, that can also
simplify the trailing storage case:

+		if (bytes & 2)
+			put_unaligned_le16((u16)random, p+i);
+		if (bytes & 1)
+			p[i+bytes-1] = (u8)(random >> 16);

>> +	for (i = 0; i < round_down(bytes, sizeof(u32)); i += sizeof(u32))
>> +		put_unaligned_le32(prandom_u32_state(state), p+i);

> Nit: 'p + i'

I don't really care, but I'm happy without the spaces; I add them
to show what binds more weakly, and in this case that's the
argument-separating comma.

>> +		p[i] = (u8)random;

> Nit: '(u8) random'

Actually, my style and most of the kerel is to not put
a space in a cast, since it binds so tighty.

E.g. compare

git grep ')[a-z]' kernel/
git grep ') [a-z]' kernel/

Notice that the second is alsmost all comments.
(There are some spaces in kernel/ptrace.v.)

I'd rather leave it without the space unless you feel
very strongly about it.
