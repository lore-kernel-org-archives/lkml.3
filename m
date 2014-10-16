Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaJPMcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:32:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbaJPMcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:32:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5432A4F1.4040507@samsung.com>
References: <5432A4F1.4040507@samsung.com> <20141003143012.26457.54004.stgit@warthog.procyon.org.uk>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH 0/3] MODSIGN: Use PKCS#7 cert to avoid SKIDs
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1892.1413462701.1@warthog.procyon.org.uk>
Date: Thu, 16 Oct 2014 13:31:41 +0100
Message-ID: <1893.1413462701@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> /tmp/ccgSFKJd.o: In function `display_openssl_errors':
> sign-file.c:(.text+0x4e): undefined reference to `ERR_peek_error'
> sign-file.c:(.text+0xa1): undefined reference to `ERR_error_string'
> ...

Is this solved for you by making the attached change?

David
---

diff --git a/scripts/Makefile b/scripts/Makefile
index 1d9c40be606e..719311b7bd46 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -20,7 +20,7 @@ hostprogs-$(CONFIG_MODULE_SIG)	 += sign-file
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
-HOSTCFLAGS_sign-file.o = -lcrypto
+HOSTLOADLIBES_sign-file = -lcrypto
