Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3KDQft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:35:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab3KDQfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:35:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/9] KEYS: The RSA public key algorithm needs to select
 MPILIB
To: d.kasatkin@samsung.com, zohar@us.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 16:22:24 +0000
Message-ID: <20131104162224.10177.83605.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RSA public key algorithm needs to select MPILIB directly in Kconfig as the
'select' directive is not recursive and is thus MPILIB is not enabled by
selecting MPILIB_EXTRA.

Without this, the following errors can occur:

	crypto/built-in.o: In function `RSA_verify_signature':
	rsa.c:(.text+0x1d347): undefined reference to `mpi_get_nbits'
	rsa.c:(.text+0x1d354): undefined reference to `mpi_get_nbits'
	rsa.c:(.text+0x1d36e): undefined reference to `mpi_cmp_ui'
	rsa.c:(.text+0x1d382): undefined reference to `mpi_cmp'
	rsa.c:(.text+0x1d391): undefined reference to `mpi_alloc'
	rsa.c:(.text+0x1d3b0): undefined reference to `mpi_powm'
	rsa.c:(.text+0x1d3c3): undefined reference to `mpi_free'
	rsa.c:(.text+0x1d3d8): undefined reference to `mpi_get_buffer'
	rsa.c:(.text+0x1d4d4): undefined reference to `mpi_free'
	rsa.c:(.text+0x1d503): undefined reference to `mpi_get_nbits'

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
---

 crypto/asymmetric_keys/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 82e7d6b0c276..03a6eb95ab50 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -23,6 +23,7 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 config PUBLIC_KEY_ALGO_RSA
 	tristate "RSA public-key algorithm"
 	select MPILIB_EXTRA
+	select MPILIB
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
 

