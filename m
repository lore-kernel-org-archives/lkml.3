Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3KNSQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:16:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab3KNSQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:16:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1384368349.2550.17.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1384368349.2550.17.camel@dhcp-9-2-203-236.watson.ibm.com> <20131104162216.10177.98067.stgit@warthog.procyon.org.uk> <20131104162321.10177.34033.stgit@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, d.kasatkin@samsung.com, zohar@us.ibm.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] KEYS: Fix encrypted key type update method
Date: Thu, 14 Nov 2013 17:59:51 +0000
Message-ID: <29885.1384451991@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Is there a keyutils git repo with a version of keyctl that supports the
> control option?

http://git.kernel.org/cgit/linux/kernel/git/dhowells/keyutils.git/log/?h=development

> - type size_t is unsigned, no need to verify that it is negative.

It doesn't hurt either...

> - missing Documentation/security/keys-trusted-encrypted.txt updates

Fixed (see diff below), but I suspect trusted_update() also needs scrutiny.

> - the encrypted_preparse() comment still says 'encrypted_instantiate'

Fixed.

David
---
diff --git a/Documentation/security/keys-trusted-encrypted.txt b/Documentation/security/keys-trusted-encrypted.txt
index e105ae97a4f5..78794adf445d 100644
--- a/Documentation/security/keys-trusted-encrypted.txt
+++ b/Documentation/security/keys-trusted-encrypted.txt
@@ -61,7 +61,7 @@ Usage:
     keyctl add encrypted name "new [format] key-type:master-key-name keylen"
         ring
     keyctl add encrypted name "load hex_blob" ring
-    keyctl update keyid "update key-type:master-key-name"
+    keyctl control keyid encrypted change-master-key "key-type:master-key-name"
 
 format:= 'default | ecryptfs'
 key-type:= 'trusted' | 'user'
