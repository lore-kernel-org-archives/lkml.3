Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbaGGXy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbaGGXyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>, Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH 3.14 87/94] audit: remove superfluous new- prefix in AUDIT_LOGIN messages
Date: Mon,  7 Jul 2014 16:58:17 -0700
Message-Id: <20140707235759.333887306@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

commit aa589a13b5d00d3c643ee4114d8cbc3addb4e99f upstream.

The new- prefix on ses and auid are un-necessary and break ausearch.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Reported-by: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/auditsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1991,7 +1991,7 @@ static void audit_log_set_loginuid(kuid_
 	if (!ab)
 		return;
 	audit_log_format(ab, "pid=%d uid=%u"
-			 " old-auid=%u new-auid=%u old-ses=%u new-ses=%u"
+			 " old-auid=%u auid=%u old-ses=%u ses=%u"
 			 " res=%d",
 			 current->pid, uid,
 			 oldloginuid, loginuid, oldsessionid, sessionid,


