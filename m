Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbaBUAq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:46:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbaBTXvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.10 63/66] EDAC: Replace strict_strtol() with kstrtol()
Date: Thu, 20 Feb 2014 15:52:02 -0800
Message-Id: <20140220234911.293415057@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingoo Han <jg1.han@samsung.com>

commit c542b53da9ffa4fe9de61149818a06aacae531f8 upstream.

The usage of strict_strtol() is not preferred, because strict_strtol()
is obsolete. Thus, kstrtol() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/edac_mc_sysfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -58,8 +58,10 @@ static int edac_set_poll_msec(const char
 	if (!val)
 		return -EINVAL;
 
-	ret = strict_strtol(val, 0, &l);
-	if (ret == -EINVAL || ((int)l != l))
+	ret = kstrtol(val, 0, &l);
+	if (ret)
+		return ret;
+	if ((int)l != l)
 		return -EINVAL;
 	*((int *)kp->arg) = l;
 


