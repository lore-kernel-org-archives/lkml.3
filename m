Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3H2XyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:54:12 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:47752 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3H2XyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:54:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
References: <87ob8gys0d.fsf@xmission.com>
Date: Thu, 29 Aug 2013 16:54:00 -0700
In-Reply-To: <87ob8gys0d.fsf@xmission.com> (Eric W. Biederman's message of
	"Thu, 29 Aug 2013 16:52:18 -0700")
Message-ID: <87eh9cyrxj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18bXwDFXj064r9Dqk9ZdGGQsDTtH/+uIVs=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0593]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 2/5] userns: Allow PR_CAPBSET_DROP in a user namespace.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As the capabilites and capability bounding set are per user namespace
properties it is safe to allow changing them with just CAP_SETPCAP
permission in the user namespace.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Tested-by: Richard Weinberger <richard@nod.at>
---
 security/commoncap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index c44b6fe..9fccf71 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -824,7 +824,7 @@ int cap_task_setnice(struct task_struct *p, int nice)
  */
 static long cap_prctl_drop(struct cred *new, unsigned long cap)
 {
-	if (!capable(CAP_SETPCAP))
+	if (!ns_capable(current_user_ns(), CAP_SETPCAP))
 		return -EPERM;
 	if (!cap_valid(cap))
 		return -EINVAL;
-- 
1.7.5.4

