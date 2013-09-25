Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3IYAcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:32:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3IYAUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 077/117] HID: picolcd_core: validate output report details
Date: Tue, 24 Sep 2013 17:19:03 -0700
Message-Id: <20130925001749.366234284@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 1e87a2456b0227ca4ab881e19a11bb99d164e792 upstream.

A HID device could send a malicious output report that would cause the
picolcd HID driver to trigger a NULL dereference during attr file writing.

[jkosina@suse.cz: changed

	report->maxfield < 1

to

	report->maxfield != 1

as suggested by Bruno].

CVE-2013-2899

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Bruno Prémont <bonbons@linux-vserver.org>
Acked-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-picolcd_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -290,7 +290,7 @@ static ssize_t picolcd_operation_mode_st
 		buf += 10;
 		cnt -= 10;
 	}
-	if (!report)
+	if (!report || report->maxfield != 1)
 		return -EINVAL;
 
 	while (cnt > 0 && (buf[cnt-1] == '\n' || buf[cnt-1] == '\r'))


