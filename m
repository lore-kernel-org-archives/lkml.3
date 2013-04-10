Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937555Ab3DJWvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:51:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937550Ab3DJWvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:51:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Guy Briggs <rbriggs@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 15/19] thermal: return an error on failure to register thermal class
Date: Wed, 10 Apr 2013 15:50:38 -0700
Message-Id: <20130410225028.382884020@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410225026.833809117@linuxfoundation.org>
References: <20130410225026.833809117@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rbriggs@redhat.com>

commit da28d966f6aa942ae836d09729f76a1647932309 upstream.

The return code from the registration of the thermal class is used to
unallocate resources, but this failure isn't passed back to the caller of
thermal_init.  Return this failure back to the caller.

This bug was introduced in changeset 4cb18728 which overwrote the return code
when the variable was re-used to catch the return code of the registration of
the genetlink thermal socket family.

Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thermal/thermal_sys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1319,6 +1319,7 @@ static int __init thermal_init(void)
 		idr_destroy(&thermal_cdev_idr);
 		mutex_destroy(&thermal_idr_lock);
 		mutex_destroy(&thermal_list_lock);
+		return result;
 	}
 	result = genetlink_init();
 	return result;


