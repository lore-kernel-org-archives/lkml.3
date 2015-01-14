Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbbANHjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:39:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbbANHjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:39:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>, Nishanth Menon <nm@ti.com>,
        Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 36/44] scripts/kernel-doc: dont eat struct members with __aligned
Date: Tue, 13 Jan 2015 23:23:57 -0800
Message-Id: <20150114072229.386726507@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072227.419663002@linuxfoundation.org>
References: <20150114072227.419663002@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 7b990789a4c3420fa57596b368733158e432d444 upstream.

The change from \d+ to .+ inside __aligned() means that the following
structure:

  struct test {
        u8 a __aligned(2);
        u8 b __aligned(2);
  };

essentially gets modified to

  struct test {
        u8 a;
  };

for purposes of kernel-doc, thus dropping a struct member, which in
turns causes warnings and invalid kernel-doc generation.

Fix this by replacing the catch-all (".") with anything that's not a
semicolon ("[^;]").

Fixes: 9dc30918b23f ("scripts/kernel-doc: handle struct member __aligned without numbers")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1750,7 +1750,7 @@ sub dump_struct($$) {
 	# strip kmemcheck_bitfield_{begin,end}.*;
 	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 	# strip attributes
-	$members =~ s/__aligned\s*\(.+\)//gos;
+	$members =~ s/__aligned\s*\([^;]*\)//gos;
 
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);


