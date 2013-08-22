Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3HVLFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:05:51 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:35549 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab3HVLFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:05:47 -0400
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH 13/18] Hibernate: Avoid S4 sign key data included in snapshot image
Date: Thu, 22 Aug 2013 19:01:52 +0800
Message-Id: <1377169317-5959-14-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1377169317-5959-1-git-send-email-jlee@suse.com>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add swsusp_page_is_sign_key() method to hibernate_key.c and
check the page is S4 sign key data when collect saveable page in
snapshot.c to avoid sign key data included in snapshot image.

Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 kernel/power/snapshot.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 72e2911..9e4c94b 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -860,6 +860,9 @@ static struct page *saveable_highmem_page(struct zone *zone, unsigned long pfn)
 
 	BUG_ON(!PageHighMem(page));
 
+	if (swsusp_page_is_sign_key(page))
+		return NULL;
+
 	if (swsusp_page_is_forbidden(page) ||  swsusp_page_is_free(page) ||
 	    PageReserved(page))
 		return NULL;
@@ -922,6 +925,9 @@ static struct page *saveable_page(struct zone *zone, unsigned long pfn)
 
 	BUG_ON(PageHighMem(page));
 
+	if (swsusp_page_is_sign_key(page))
+		return NULL;
+
 	if (swsusp_page_is_forbidden(page) || swsusp_page_is_free(page))
 		return NULL;
 
-- 
1.6.4.2

