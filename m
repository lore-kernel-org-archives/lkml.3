Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3BMNr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:47:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab3BMNrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:47:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1360130301-9031-1-git-send-email-jlee@suse.com>
References: <1360130301-9031-1-git-send-email-jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] X.509: Support parse long form of length octets in Authority Key Identifier
Date: Wed, 13 Feb 2013 13:47:00 +0000
Message-ID: <18786.1360763220@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:

> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>

Without the comma, please.

> +		/* Short Form length */
> +		if (vlen <= 127) {
> +
> +			if (v[1] != vlen - 2 ||

There's an unnecessary blank line there.  I would also move the comment inside
the if-body.

> +			int sub = v[1] - 0x80;

I recommend you use an unsigned int or size_t variable.

Also, you should use ASN1_INDEFINITE_LENGTH rather than writing 0x80 and 127.

> +			v += 4;
> +			key_len = v[3];

Are you sure that is correct?  You altered v before doing v[3].  I would stick
with key_len = vlen - 4.

> +			/* calculate the length from subsequent octet */

"... octets".

> +				seq_len |= v[2 + i];

Add 2 to v before entering the loop.

> +			/* check vlen should not less then length of keyid */

vlen should be exactly equal to key id, shouldn't it?  Leastways, that's what
you're checking...

> +			v += (4 + sub);
> +			key_len = v[3 + sub];

Again, this doesn't look right.  Besides, you should be able to work out
key_len from vlen, subtracting the metadata size.

David
