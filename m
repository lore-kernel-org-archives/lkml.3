Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3JQXcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:32:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37646 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3JQXcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:32:05 -0400
Message-ID: <52607371.3060805@infradead.org>
Date: Thu, 17 Oct 2013 16:32:01 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>
Subject: [PATCH] scripts/kernel-doc: make unknown function prototype a Warning
 instead of an Error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

When scripts/kernel-doc cannot understand a function prototype,
it had been generating a fatal error and stopping immediately.
Make this a Warning instead of an Error and keep going.

Note that this can happen if the kernel-doc notation that is being
parsed is not actually a function prototype; maybe it's a struct or
something else, so I added "function" to the warning message to try
to make it clearer that scripts/kernel-doc is looking for a function
prototype here.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Mark Brown <broonie@kernel.org>
---
 scripts/kernel-doc |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-3.12-rc5.orig/scripts/kernel-doc
+++ linux-3.12-rc5/scripts/kernel-doc
@@ -2125,8 +2125,7 @@ sub dump_function($$) {
 
 	create_parameterlist($args, ',', $file);
     } else {
-	print STDERR "Error(${file}:$.): cannot understand prototype: '$prototype'\n";
-	++$errors;
+	print STDERR "Warning(${file}:$.): cannot understand function prototype: '$prototype'\n";
 	return;
     }
 
