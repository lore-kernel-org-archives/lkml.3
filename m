Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934991Ab3BTMyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:54:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742Ab3BTMyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:54:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1361341056-10745-1-git-send-email-jlee@suse.com>
References: <1361341056-10745-1-git-send-email-jlee@suse.com>
To: Chun-Yi Lee <joeyli.kernel@gmail.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Chun-Yi Lee <jlee@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] X.509: Support parse long form of length octets in Authority Key Identifier
Date: Wed, 20 Feb 2013 12:49:46 +0000
Message-ID: <1794.1361364586@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chun-Yi Lee <joeyli.kernel@gmail.com> wrote:

> Per X.509 spec in 4.2.1.1 section, the structure of Authority Key
> Identifier Extension is:
> 
>    AuthorityKeyIdentifier ::= SEQUENCE {
>       keyIdentifier             [0] KeyIdentifier           OPTIONAL,
>       authorityCertIssuer       [1] GeneralNames            OPTIONAL,
>       authorityCertSerialNumber [2] CertificateSerialNumber OPTIONAL  }
> 
>    KeyIdentifier ::= OCTET STRING
> 
> When a certificate also provides
> authorityCertIssuer and authorityCertSerialNumber then the length of
> AuthorityKeyIdentifier SEQUENCE is likely to long form format.
> e.g.
>    The example certificate demos/tunala/A-server.pem in openssl source:
> 
> X509v3 Authority Key Identifier:
>     keyid:49:FB:45:72:12:C4:CC:E1:45:A1:D3:08:9E:95:C4:2C:6D:55:3F:17
>     DirName:/C=NZ/L=Wellington/O=Really Irresponsible Authorisation Authority (RIAA)/OU=Cert-stamping/CN=Jackov al-Trades/emailAddress=none@fake.domain
>     serial:00
> 
> Current parsing rule of OID_authorityKeyIdentifier only take care the
> short form format, it causes load certificate to modsign_keyring fail:
> 
> [   12.061147] X.509: Extension: 47
> [   12.075121] MODSIGN: Problem loading in-kernel X.509 certificate (-74)
> 
> So, this patch add the parsing rule for support long form format against
> Authority Key Identifier.
> 
> v2:
>  - Removed comma from author's name.
>  - Moved 'Short Form length' comment inside the if-body.
>  - Changed the type of sub to size_t.
>  - Use ASN1_INDEFINITE_LENGTH rather than writing 0x80 and 127.
>  - Moved the key_len's value assignment before alter v.
>  - Fixed the typo of octets.
>  - Add 2 to v before entering the loop for calculate the length.
>  - Removed the comment of check vlen.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Josh Boyer <jwboyer@redhat.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Chun-Yi Lee <jlee@suse.com>

Acked-by: David Howells <dhowells@redhat.com>
