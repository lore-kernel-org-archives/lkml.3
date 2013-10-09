Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3JIB00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:26:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:6638 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab3JIB0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:26:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1059,1371106800"; 
   d="scan'208";a="407990812"
Date: Wed, 9 Oct 2013 09:26:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: [PATCH] kobject: show debug info on delayed kobject release
Message-ID: <20131009012621.GA7126@localhost>
References: <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
 <20131008020918.GA1220@localhost>
 <20131008021452.GA6456@localhost>
 <CA+55aFwrovZf-LYa=_SyMNvqQkTfxREm0YuzDk8wJy+Krs0xzw@mail.gmail.com>
 <20131008031152.GA8218@localhost>
 <20131008121742.GA29280@localhost>
 <20131008221417.GF25034@n2100.arm.linux.org.uk>
 <20131008224840.GA15303@kroah.com>
 <CA+55aFzdABn=TiBbM0fdok1xO3UY7hUjXA8q7rUrg2dHCsN=Ng@mail.gmail.com>
 <20131009011833.GA14579@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009011833.GA14579@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful for locating buggy drivers on kernel oops.

It may add dozens of new lines to boot dmesg. DEBUG_KOBJECT_RELEASE is
hopefully only enabled in debug kernels (like maybe the Fedora rawhide
one, or at developers), so being a bit more verbose is likely ok.

CC: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 lib/kobject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 669bf19..084f7b1 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -592,7 +592,7 @@ static void kobject_release(struct kref *kref)
 {
 	struct kobject *kobj = container_of(kref, struct kobject, kref);
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
-	pr_debug("kobject: '%s' (%p): %s, parent %p (delayed)\n",
+	pr_info("kobject: '%s' (%p): %s, parent %p (delayed)\n",
 		 kobject_name(kobj), kobj, __func__, kobj->parent);
 	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
 	schedule_delayed_work(&kobj->release, HZ);
-- 
1.7.10.4

