Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaLWOiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:38:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39594 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaLWOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:37:59 -0500
Date: Tue, 23 Dec 2014 06:37:46 -0800
From: tip-bot for Sylvain BERTRAND <tipbot@zytor.com>
Message-ID: <tip-ea174f4c4f6135e30a4e1e8c4511980338238b16@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sylvain.bertrand@gmail.com, mingo@kernel.org,
        hpa@zytor.com, tglx@linutronix.de
Reply-To: sylvain.bertrand@gmail.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@kernel.org
In-Reply-To: <20141223123912.GA1386@localhost.localdomain>
References: <20141223123912.GA1386@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix mkcapflags.sh bash-ism
Git-Commit-ID: ea174f4c4f6135e30a4e1e8c4511980338238b16
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea174f4c4f6135e30a4e1e8c4511980338238b16
Gitweb:     http://git.kernel.org/tip/ea174f4c4f6135e30a4e1e8c4511980338238b16
Author:     Sylvain BERTRAND <sylvain.bertrand@gmail.com>
AuthorDate: Tue, 23 Dec 2014 13:39:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Dec 2014 15:34:57 +0100

x86: Fix mkcapflags.sh bash-ism

Chocked while compiling linux with dash shell instead of bash
shell. See:

   http://pubs.opengroup.org/onlinepubs/9699919799/utilities/test.html

Signed-off-by: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
Link: http://lkml.kernel.org/r/20141223123912.GA1386@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/mkcapflags.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mkcapflags.sh b/arch/x86/kernel/cpu/mkcapflags.sh
index e2b22df..36d99a3 100644
--- a/arch/x86/kernel/cpu/mkcapflags.sh
+++ b/arch/x86/kernel/cpu/mkcapflags.sh
@@ -28,7 +28,7 @@ function dump_array()
 		# If the /* comment */ starts with a quote string, grab that.
 		VALUE="$(echo "$i" | sed -n 's@.*/\* *\("[^"]*"\).*\*/@\1@p')"
 		[ -z "$VALUE" ] && VALUE="\"$NAME\""
-		[ "$VALUE" == '""' ] && continue
+		[ "$VALUE" = '""' ] && continue
 
 		# Name is uppercase, VALUE is all lowercase
 		VALUE="$(echo "$VALUE" | tr A-Z a-z)"
