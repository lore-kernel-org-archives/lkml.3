Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaG1LzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:55:25 -0400
Received: from ozlabs.org ([103.22.144.67]:60723 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbaG1LzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:55:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the modules tree
In-Reply-To: <20140728135859.7977890b@canb.auug.org.au>
References: <20140728135859.7977890b@canb.auug.org.au>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 28 Jul 2014 21:08:07 +0930
Message-ID: <87egx5ww68.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Hi Rusty,
>
> After merging the modules tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:

Thanks, I've sent off a fix for that file, and asked Stewart for an
Ack:

Subject: arch/powerpc/platforms/powernv/opal-elog.c: fix world-writable sysfs files

If you don't have a store function, you're not writable anyway!

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/powerpc/platforms/powernv/opal-elog.c b/arch/powerpc/platforms/powernv/opal-elog.c
index 10268c41d830..d59dc2a60260 100644
--- a/arch/powerpc/platforms/powernv/opal-elog.c
+++ b/arch/powerpc/platforms/powernv/opal-elog.c
@@ -82,9 +82,9 @@ static ssize_t elog_ack_store(struct elog_obj *elog_obj,
 }
 
 static struct elog_attribute id_attribute =
-	__ATTR(id, 0666, elog_id_show, NULL);
+	__ATTR_RO(id, elog_id_show);
 static struct elog_attribute type_attribute =
-	__ATTR(type, 0666, elog_type_show, NULL);
+	__ATTR_RO(type, elog_type_show);
 static struct elog_attribute ack_attribute =
 	__ATTR(acknowledge, 0660, elog_ack_show, elog_ack_store);
 
