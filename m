Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbbAYSL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:11:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120AbbAYSKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 3.18 178/183] kbuild: Fix removal of the debian/ directory
Date: Sun, 25 Jan 2015 10:08:20 -0800
Message-Id: <20150125180817.890902140@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Marek <mmarek@suse.cz>

commit a16c5f99a28c9945165c46da27fff8e6f26f8736 upstream.

scripts/Makefile.clean treats absolute path specially, but
$(objtree)/debian is no longer an absolute path since 7e1c0477 (kbuild:
Use relative path for $(objtree). Work around this by checking if the
path starts with $(objtree)/.

Reported-and-tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Fixes: 7e1c0477 (kbuild: Use relative path for $(objtree)
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/Makefile.clean |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -45,19 +45,19 @@ __clean-files	:= $(extra-y) $(extra-m) $
 
 __clean-files   := $(filter-out $(no-clean-files), $(__clean-files))
 
-# as clean-files is given relative to the current directory, this adds
-# a $(obj) prefix, except for absolute paths
+# clean-files is given relative to the current directory, unless it
+# starts with $(objtree)/ (which means "./", so do not add "./" unless
+# you want to delete a file from the toplevel object directory).
 
 __clean-files   := $(wildcard                                               \
-                   $(addprefix $(obj)/, $(filter-out /%, $(__clean-files))) \
-		   $(filter /%, $(__clean-files)))
+		   $(addprefix $(obj)/, $(filter-out $(objtree)/%, $(__clean-files))) \
+		   $(filter $(objtree)/%, $(__clean-files)))
 
-# as clean-dirs is given relative to the current directory, this adds
-# a $(obj) prefix, except for absolute paths
+# same as clean-files
 
 __clean-dirs    := $(wildcard                                               \
-                   $(addprefix $(obj)/, $(filter-out /%, $(clean-dirs)))    \
-		   $(filter /%, $(clean-dirs)))
+		   $(addprefix $(obj)/, $(filter-out $(objtree)/%, $(clean-dirs)))    \
+		   $(filter $(objtree)/%, $(clean-dirs)))
 
 # ==========================================================================
 


