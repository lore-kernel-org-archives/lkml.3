Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaKXAAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 19:00:54 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46268 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaKXAAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 19:00:52 -0500
Message-ID: <1416787243.9616.4.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 2/5] X.509: Support X.509 lookup by Issuer+Serial form
 AuthorityKeyIdentifier
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: mmarek@suse.cz, d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        vgoyal@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 23 Nov 2014 19:00:43 -0500
In-Reply-To: <20141120165414.5264.95354.stgit@warthog.procyon.org.uk>
References: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
	 <20141120165414.5264.95354.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112400-8236-0000-0000-00000725BFF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't assume that the issuer & serialNumber are specified.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
crypto/asymmetric_keys/x509_public_key.c | 11 +++++++----
1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c
b/crypto/asymmetric_keys/x509_public_key.c
index 9c1a3d6..510269f 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -9,6 +9,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */

+#define DEBUG 1
#define pr_fmt(fmt) "X.509: "fmt
#include <linux/module.h>
#include <linux/kernel.h>
@@ -68,12 +69,14 @@ struct key *x509_request_asymmetric_key(struct key
*keyring,
{
struct key *key;
key_ref_t ref;
- const char *lookup;
+ const char *lookup = NULL;
char *req, *p;
- int len;
+ int len = 0;

- lookup = id->data;
- len = id->len;
+        if (id) {
+ lookup = id->data;
+ len = id->len;
+ }
if (!lookup) {
lookup = skid->data;
len = skid->len;
-- 
1.8.1.4



