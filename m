Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbbAMO5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 09:57:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbbAMO5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 09:57:13 -0500
Date: Tue, 13 Jan 2015 15:57:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] MODSIGN: /proc/keys is not unconditionally available
Message-ID: <alpine.LNX.2.00.1501131555510.4162@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/module-signing.txt file is referring to /proc/keys file in 
order to view all keys contained in the kernel's keyring. That file is not 
universally avialble when CONFIG_KEYS is enabled, which is confusing. The 
fact that the option needed for this procfs interface to exist contains 
"_DEBUG_" in its name makes it even more confusing. Document this fact.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/module-signing.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
index 09c2382..09be78d 100644
--- a/Documentation/module-signing.txt
+++ b/Documentation/module-signing.txt
@@ -152,6 +152,9 @@ in a keyring called ".system_keyring" that can be seen by:
 	302d2d52 I------     1 perm 1f010000     0     0 asymmetri Fedora kernel signing key: d69a84e6bce3d216b979e9505b3e3ef9a7118079: X509.RSA a7118079 []
 	...
 
+CONFIG_KEYS_DEBUG_PROC_KEYS needs to be enabled for the above procfs interface
+to be available.
+
 Beyond the public key generated specifically for module signing, any file
 placed in the kernel source root directory or the kernel build root directory
 whose name is suffixed with ".x509" will be assumed to be an X.509 public key

-- 
Jiri Kosina
SUSE Labs
