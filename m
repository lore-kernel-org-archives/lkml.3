Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3BNIJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:09:45 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:37625 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab3BNIJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:09:44 -0500
Subject: Re: [PATCH] X.509: Support parse long form of length octets in
 Authority Key Identifier
From: joeyli <jlee@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <18786.1360763220@warthog.procyon.org.uk>
References: <1360130301-9031-1-git-send-email-jlee@suse.com>
	 <18786.1360763220@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Feb 2013 16:08:44 +0800
Message-ID: <1360829324.6359.103.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, 

First, thanks for your review and comments!

於 三，2013-02-13 於 13:47 +0000，David Howells 提到：
> Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> 
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> 
> Without the comma, please.
> 
> > +		/* Short Form length */
> > +		if (vlen <= 127) {
> > +
> > +			if (v[1] != vlen - 2 ||
> 
> There's an unnecessary blank line there.  I would also move the comment inside
> the if-body.

I will move the comment to if-body, thanks!

> 
> > +			int sub = v[1] - 0x80;
> 
> I recommend you use an unsigned int or size_t variable.

Yes, using size_t is better, will change it.

> 
> Also, you should use ASN1_INDEFINITE_LENGTH rather than writing 0x80 and 127.

Thanks, will change it.

> 
> > +			v += 4;
> > +			key_len = v[3];
> 
> Are you sure that is correct?  You altered v before doing v[3].  I would stick
> with key_len = vlen - 4.

Sorry for my stupid mistake!

It causes by I changed the key_len's value assignment from before check
length of vlen to after, the reason is just want source code "looks
better".

I will fix it, appreciate for your correction!

> 
> > +			/* calculate the length from subsequent octet */
> 
> "... octets".
> 

I will fix the typo, thanks!

> > +				seq_len |= v[2 + i];
> 
> Add 2 to v before entering the loop.

Thanks for your suggestion, it's a better style, I will change it.

> 
> > +			/* check vlen should not less then length of keyid */
> 
> vlen should be exactly equal to key id, shouldn't it?  Leastways, that's what
> you're checking...

hm... no, the value of vlen should be equal or bigger then the length of
key id, because the AuthorityKeyIdentifier SEQUENCE may also includes
authorityCertIssuer and authorityCertSerialNumber but not just
keyIdentifier. So, it's possible:

 a. vlen = length of keyIdentifier	(short form)
 b. vlen = length of authorityCertIssuer + length of authorityCertSerialNumber (long form)
 c. vlen = length of keyIdentifier + length of authorityCertIssuer + length of authorityCertSerialNumber (long form)

But, you are right, the first element in AuthorityKeyIdentifier SEQUENCE
maybe is not keyIdentifier, the authorityCertIssuer is also possible the
first element when there have no keyIdentifier.

I will direct remove the comment for avoid the confusing.

> 
> > +			v += (4 + sub);
> > +			key_len = v[3 + sub];
> 
> Again, this doesn't look right.  Besides, you should be able to work out
> key_len from vlen, subtracting the metadata size.
> 
> David
> 

Sorry for my stupid mistake again, I will fix it!


Thanks a lot!
Joey Lee

