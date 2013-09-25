Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab3IYAVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:21:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab3IYAVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:21:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Wladislav Wiebe <wladislav.kw@gmail.com>
Subject: [ 111/117] of: Fix missing memory initialization on FDT unflattening
Date: Tue, 24 Sep 2013 17:19:37 -0700
Message-Id: <20130925001753.060891663@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grant Likely <grant.likely@linaro.org>

commit 0640332e073be9207f0784df43595c0c39716e42 upstream.

Any calls to dt_alloc() need to be zeroed. This is a temporary fix, but
the allocation function itself needs to zero memory before returning
it. This is a follow up to patch 9e4012752, "of: fdt: fix memory
initialization for expanded DT" which fixed one call site but missed
another.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Acked-by: Wladislav Wiebe <wladislav.kw@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/base.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1629,6 +1629,7 @@ void of_alias_scan(void * (*dt_alloc)(u6
 		ap = dt_alloc(sizeof(*ap) + len + 1, 4);
 		if (!ap)
 			continue;
+		memset(ap, 0, sizeof(*ap) + len + 1);
 		ap->alias = start;
 		of_alias_add(ap, np, id, start, len);
 	}


