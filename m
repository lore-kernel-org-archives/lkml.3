Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab3BUDeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 22:34:36 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:57407 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3BUDed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 22:34:33 -0500
Subject: Re: [PATCH v2] X.509: Support parse long form of length octets in
 Authority Key Identifier
From: joeyli <jlee@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1794.1361364586@warthog.procyon.org.uk>
References: <1361341056-10745-1-git-send-email-jlee@suse.com>
	 <1794.1361364586@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Feb 2013 11:33:34 +0800
Message-ID: <1361417614.8705.27.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-02-20 於 12:49 +0000，David Howells 提到：
> Chun-Yi Lee <joeyli.kernel@gmail.com> wrote:
> 
> > Per X.509 spec in 4.2.1.1 section, the structure of Authority Key
> > Identifier Extension is:
> > 
> >    AuthorityKeyIdentifier ::= SEQUENCE {
> >       keyIdentifier             [0] KeyIdentifier           OPTIONAL,
> >       authorityCertIssuer       [1] GeneralNames            OPTIONAL,
> >       authorityCertSerialNumber [2] CertificateSerialNumber OPTIONAL  }
> > 
> >    KeyIdentifier ::= OCTET STRING
> > 
> > When a certificate also provides
> > authorityCertIssuer and authorityCertSerialNumber then the length of
> > AuthorityKeyIdentifier SEQUENCE is likely to long form format.
> > e.g.
> >    The example certificate demos/tunala/A-server.pem in openssl source:
> > 
> > X509v3 Authority Key Identifier:
> >     keyid:49:FB:45:72:12:C4:CC:E1:45:A1:D3:08:9E:95:C4:2C:6D:55:3F:17
> >     DirName:/C=NZ/L=Wellington/O=Really Irresponsible Authorisation Authority (RIAA)/OU=Cert-stamping/CN=Jackov al-Trades/emailAddress=none@fake.domain
> >     serial:00
> > 
> > Current parsing rule of OID_authorityKeyIdentifier only take care the
> > short form format, it causes load certificate to modsign_keyring fail:
> > 
> > [   12.061147] X.509: Extension: 47
> > [   12.075121] MODSIGN: Problem loading in-kernel X.509 certificate (-74)
> > 
> > So, this patch add the parsing rule for support long form format against
> > Authority Key Identifier.
> > 
> > v2:
> >  - Removed comma from author's name.
> >  - Moved 'Short Form length' comment inside the if-body.
> >  - Changed the type of sub to size_t.
> >  - Use ASN1_INDEFINITE_LENGTH rather than writing 0x80 and 127.
> >  - Moved the key_len's value assignment before alter v.
> >  - Fixed the typo of octets.
> >  - Add 2 to v before entering the loop for calculate the length.
> >  - Removed the comment of check vlen.
> > 
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Josh Boyer <jwboyer@redhat.com>
> > Cc: Randy Dunlap <rdunlap@xenotime.net>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Signed-off-by: Chun-Yi Lee <jlee@suse.com>
> 
> Acked-by: David Howells <dhowells@redhat.com>
> 

Thanks for David's review and confirm.

Joey Lee


