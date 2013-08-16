Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3HPNSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:18:11 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42496 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3HPNSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:18:06 -0400
Subject: [RFC PATCH v2 03/11] pstore/Kconfig: Select ZLIB_DEFLATE and
 ZLIB_INFLATE when PSTORE is selected
To: linuxppc-dev@ozlabs.org, tony.luck@intel.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, ananth@in.ibm.com, benh@kernel.crashing.org,
        cbouatmailru@gmail.com, mahesh@linux.vnet.ibm.com, ccross@android.com
Date: Fri, 16 Aug 2013 18:47:55 +0530
Message-ID: <20130816131755.3338.84273.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081613-7014-0000-0000-00000379829D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pstore will make use of deflate and inflate algorithm to compress and decompress
the data. So when Pstore is enabled select zlib_deflate and zlib_inflate.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 fs/pstore/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index ca71db6..983d951 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -1,6 +1,8 @@
 config PSTORE
 	bool "Persistent store support"
 	default n
+	select ZLIB_DEFLATE
+	select ZLIB_INFLATE
 	help
 	   This option enables generic access to platform level
 	   persistent storage via "pstore" filesystem that can

