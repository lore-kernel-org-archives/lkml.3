Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab3GOQzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:55:53 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40003 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab3GOQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:55:50 -0400
Subject: [PATCH 03/11] pstore/Kconfig: Select ZLIB_DEFLATE and ZLIB_INFLATE
 when PSTORE is selected
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 15 Jul 2013 22:25:37 +0530
Message-ID: <20130715165537.1520.88939.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071516-9264-0000-0000-00000420BA99
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

