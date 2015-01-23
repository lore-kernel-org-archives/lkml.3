Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbbAWIhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:37:05 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:57400 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbbAWIhC convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 23 Jan 2015 03:37:02 -0500
Message-Id: <54C2163D0200007800058921@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 23 Jan 2015 08:37:01 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/tmem: mark xen_tmem_init() __init
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a module_init() function, this should have been this way from the
beginning.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 drivers/xen/tmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.19-rc5/drivers/xen/tmem.c
+++ 3.19-rc5-xen-tmem-init/drivers/xen/tmem.c
@@ -374,7 +374,7 @@ static struct frontswap_ops tmem_frontsw
 };
 #endif
 
-static int xen_tmem_init(void)
+static int __init xen_tmem_init(void)
 {
 	if (!xen_domain())
 		return 0;



