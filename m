Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751085Ab3DVEKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 00:10:42 -0400
Received: from ozlabs.org ([203.10.76.45]:34258 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab3DVEKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 00:10:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Lee\, Chun-Yi" <joeyli.kernel@gmail.com>, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Chun-Yi Lee <jlee@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3] X.509: Support parse long form of length octets in Authority Key Identifier
In-Reply-To: <1364547153-1416-1-git-send-email-jlee@suse.com>
References: <1364547153-1416-1-git-send-email-jlee@suse.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 22 Apr 2013 11:37:21 +0930
Message-ID: <878v4bb9nq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Lee, Chun-Yi" <joeyli.kernel@gmail.com> writes:
> From: Chun-Yi Lee <jlee@suse.com>
>
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
> v3:
> Changed the size check in "Short Form length" case, we allow v[3] smaller
> then (vlen - 4) because authorityCertIssuer and authorityCertSerialNumber
> are also possible attach in AuthorityKeyIdentifier sequence.
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
> Acked-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Chun-Yi Lee <jlee@suse.com>

Applied to modules-next.

Thanks,
Rusty.
