Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab3FEWE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:04:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab3FEVfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [ 031/127] Drivers: hv: Fix a bug in get_vp_index()
Date: Wed,  5 Jun 2013 14:33:18 -0700
Message-Id: <20130605213221.496919398@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit d2242a384355773c711a936522bcfae0f35f8c2a upstream.

Linux' notion of cpuid is different from the Host's notion of CPUID. In the
call to bind the channel interrupts, we should use the host's notion of
CPU Ids. Fix this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/channel_mgmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -318,7 +318,7 @@ static u32 get_vp_index(uuid_le *type_gu
 		return 0;
 	}
 	cur_cpu = (++next_vp % max_cpus);
-	return cur_cpu;
+	return hv_context.vp_index[cur_cpu];
 }
 
 /*


