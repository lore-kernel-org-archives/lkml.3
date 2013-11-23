Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab3KWBJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 20:09:18 -0500
Received: from ore.jhcloos.com ([198.147.23.85]:59238 "EHLO ore.jhcloos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab3KWBJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 20:09:15 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Nov 2013 20:09:15 EST
From: James Cloos <cloos@jhcloos.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.13-rc1 is out
In-Reply-To: <CA+55aFxK5hkhteiL5cyPtHX5reup6aOiHQTCDKKdBsHiWsroGA@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 22 Nov 2013 12:36:37 -0800")
References: <CA+55aFxK5hkhteiL5cyPtHX5reup6aOiHQTCDKKdBsHiWsroGA@mail.gmail.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQAgMAAABinRfyAAAACVBMVEX///8ZGXBQKKnCrDQ3
 AAAAJElEQVQImWNgQAAXzwQg4SKASgAlXIEEiwsSIYBEcLaAtMEAADJnB+kKcKioAAAAAElFTkSu
 QmCC
Copyright: Copyright 2013 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Fri, 22 Nov 2013 19:51:18 -0500
Message-ID: <m3li0gndnk.fsf@carbon.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Hashcash: 1:30:131123:torvalds@linux-foundation.org::0uRJqtWxHmKh7k3J:0000000000000000000000000000000tkV1B
X-Hashcash: 1:30:131123:linux-kernel@vger.kernel.org::QLjgK7+tN8JfFfw4:00000000000000000000000000000000CAV8F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This combination:

# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_TRUSTED_KEYS=m

(acquired by oldconfig and N to system keyring)

fails with:

Pass 2
  CC [M]  crypto/asymmetric_keys/x509_rsakey-asn1.o
  CC [M]  crypto/asymmetric_keys/x509_cert_parser.o
  CC [M]  crypto/asymmetric_keys/x509_public_key.o
crypto/asymmetric_keys/x509_public_key.c: In function ‘x509_key_preparse’:
crypto/asymmetric_keys/x509_public_key.c:237:35: error: ‘system_trusted_keyring’ undeclared (first use in this function)
   ret = x509_validate_trust(cert, system_trusted_keyring);
                                   ^
crypto/asymmetric_keys/x509_public_key.c:237:35: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [crypto/asymmetric_keys/x509_public_key.o] Error 1
make[1]: *** [crypto/asymmetric_keys] Error 2
make: *** [crypto] Error 2

Perhaps include/keys/system_keyring.h should have a definition for
system_trusted_keyring in the #ifndef CONFIG_SYSTEM_TRUSTED_KEYRING
case (which may entail just removing the #ifdef).

Commits b56e5a17b6b9acd1 and 09fbc47373826d67 are relevant.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
