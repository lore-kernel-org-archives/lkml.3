Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3JIO6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:58:03 -0400
Received: from smtprelay0028.hostedemail.com ([216.40.44.28]:33352 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754250Ab3JIO6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:58:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:69:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2895:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7264:7652:7903:10004:10400:10848:11232:11658:11914:12043:12262:12291:12296:12438:12517:12519:12555:12663:12679:1268
X-HE-Tag: grain79_62908d3e0c742
X-Filterd-Recvd-Size: 3508
Message-ID: <1381330676.2050.9.camel@joe-AO722>
Subject: Re: [PATCH v2] vsprintf: Check real user/group id for %pK
From: Joe Perches <joe@perches.com>
To: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Ryan Mallon <rmallon@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>,
        jgunthorpe@obsidianresearch.com, Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 09 Oct 2013 07:57:56 -0700
In-Reply-To: <52553A8D.4090906@gmail.com>
References: <5254A034.5020700@gmail.com>
	 <1381279758.23937.42.camel@joe-AO722> <1381282200.23937.45.camel@joe-AO722>
		 <5254B787.6080700@gmail.com> <1381284056.23937.49.camel@joe-AO722>
	 <5254BDD0.7040001@gmail.com> <52553A8D.4090906@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 07:14 -0400, Dan Rosenberg wrote:
> isn't the default value of kptr_restrict 0 now, unless I'm missing
> something? If I recall it was 1 when originally written, and then
> changed to 0 at some point. Could the documentation be updated to
> reflect that?

Yeah, the default got changed by
---------------------------
commit 411f05f123cbd7f8aa1edcae86970755a6e2a9d9
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu May 12 23:00:28 2011 +0200

kptr_restrict has been triggering bugs in apps such as perf, and it also makes
the system less useful by default, so turn it off by default.
---------------------------

Maybe this:
---
 Documentation/sysctl/kernel.txt | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 9d4c1d1..c17d5ca 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -289,14 +289,15 @@ Default value is "/sbin/hotplug".
 
 kptr_restrict:
 
-This toggle indicates whether restrictions are placed on
-exposing kernel addresses via /proc and other interfaces.  When
-kptr_restrict is set to (0), there are no restrictions.  When
-kptr_restrict is set to (1), the default, kernel pointers
-printed using the %pK format specifier will be replaced with 0's
-unless the user has CAP_SYSLOG.  When kptr_restrict is set to
-(2), kernel pointers printed using %pK will be replaced with 0's
-regardless of privileges.
+This toggle indicates whether restrictions are placed on exposing kernel
+addresses via /proc and other interfaces.
+
+When kptr_restrict is set to (0), the default, there are no restrictions.
+When kptr_restrict is set to (1), kernel pointers printed using the %pK
+format specifier will be replaced with 0's unless the user has CAP_SYSLOG
+and effective user and group ids are equal to the real ids.
+When kptr_restrict is set to (2), kernel pointers printed using %pK will
+be replaced with 0's regardless of privileges.
 
 ==============================================================
 


