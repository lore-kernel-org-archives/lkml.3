Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbbAMQTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:19:25 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:62631 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbbAMQTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:19:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH] headers_check: don't warn about kexec.h
Date: Tue, 13 Jan 2015 17:19:19 +0100
Message-ID: <12825174.7oxZXDxNhV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:InKWYu6W2U7oXeD/QtDbOwaj7psDprTriHNtKKQpEpVaGv/LudX
 vZlkQbw/B1OSPr6LHFrYjKv+MLUQW563lgR0YWimJbUM3I8ASlgXPd9nCzs4btBdZo5aTv6
 D2aHzRyj2FjoncTaXwDH38Bwm2LEjylMDq7EbshScCy1HOItUs28UQiVsNurUNa4iDcKNuc
 gFhgqFTnszC60sp5zhUFQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been getting this warning for ages:

./usr/include/linux/kexec.h:61: userspace cannot reference function or variable defined in the kernel

There is no proper fix for this file, as the declaration is meant for
user space, not for the kernel, so we should work around it the
same way that we treat the seqbuf_dump() definition.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 62320f93e903..fb051848667c 100755
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -69,6 +69,10 @@ sub check_declarations
 	if ($line =~ m/^void seqbuf_dump\(void\);/) {
 		return;
 	}
+	# user-only declaration from kexec.h
+	if ($line =~ m/^extern int kexec_load/) {
+		return;
+	}
 	if ($line =~ m/^(\s*extern|unsigned|char|short|int|long|void)\b/) {
 		printf STDERR "$filename:$lineno: " .
 			      "userspace cannot reference function or " .

