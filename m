Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3H0Nl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 09:41:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33763 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3H0Nly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 09:41:54 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gnatapov@redhat.com
Subject: [PATCH 1/3] KVM: rename __kvm_io_bus_sort_cmp to kvm_io_bus_cmp
Date: Tue, 27 Aug 2013 15:41:41 +0200
Message-Id: <1377610903-12356-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377610903-12356-1-git-send-email-pbonzini@redhat.com>
References: <1377610903-12356-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the type-safe comparison function, so the double-underscore is
not related.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c6c8bbe..f7e4334 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2815,8 +2815,8 @@ static void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 	kfree(bus);
 }
 
-static inline int __kvm_io_bus_sort_cmp(const struct kvm_io_range *r1,
-                                        const struct kvm_io_range *r2)
+static inline int kvm_io_bus_cmp(const struct kvm_io_range *r1,
+                                 const struct kvm_io_range *r2)
 {
 	if (r1->addr < r2->addr)
 		return -1;
@@ -2827,7 +2827,7 @@ static inline int __kvm_io_bus_sort_cmp(const struct kvm_io_range *r1,
 
 static int kvm_io_bus_sort_cmp(const void *p1, const void *p2)
 {
-	return __kvm_io_bus_sort_cmp(p1, p2);
+	return kvm_io_bus_cmp(p1, p2);
 }
 
 static int kvm_io_bus_insert_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev,
@@ -2863,7 +2863,7 @@ static int kvm_io_bus_get_first_dev(struct kvm_io_bus *bus,
 
 	off = range - bus->range;
 
-	while (off > 0 && __kvm_io_bus_sort_cmp(&key, &bus->range[off-1]) == 0)
+	while (off > 0 && kvm_io_bus_cmp(&key, &bus->range[off-1]) == 0)
 		off--;
 
 	return off;
@@ -2879,7 +2879,7 @@ static int __kvm_io_bus_write(struct kvm_io_bus *bus,
 		return -EOPNOTSUPP;
 
 	while (idx < bus->dev_count &&
-		__kvm_io_bus_sort_cmp(range, &bus->range[idx]) == 0) {
+		kvm_io_bus_cmp(range, &bus->range[idx]) == 0) {
 		if (!kvm_iodevice_write(bus->range[idx].dev, range->addr,
 					range->len, val))
 			return idx;
@@ -2923,7 +2923,7 @@ int kvm_io_bus_write_cookie(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 
 	/* First try the device referenced by cookie. */
 	if ((cookie >= 0) && (cookie < bus->dev_count) &&
-	    (__kvm_io_bus_sort_cmp(&range, &bus->range[cookie]) == 0))
+	    (kvm_io_bus_cmp(&range, &bus->range[cookie]) == 0))
 		if (!kvm_iodevice_write(bus->range[cookie].dev, addr, len,
 					val))
 			return cookie;
@@ -2945,7 +2945,7 @@ static int __kvm_io_bus_read(struct kvm_io_bus *bus, struct kvm_io_range *range,
 		return -EOPNOTSUPP;
 
 	while (idx < bus->dev_count &&
-		__kvm_io_bus_sort_cmp(range, &bus->range[idx]) == 0) {
+		kvm_io_bus_cmp(range, &bus->range[idx]) == 0) {
 		if (!kvm_iodevice_read(bus->range[idx].dev, range->addr,
 				       range->len, val))
 			return idx;
@@ -2989,7 +2989,7 @@ int kvm_io_bus_read_cookie(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 
 	/* First try the device referenced by cookie. */
 	if ((cookie >= 0) && (cookie < bus->dev_count) &&
-	    (__kvm_io_bus_sort_cmp(&range, &bus->range[cookie]) == 0))
+	    (kvm_io_bus_cmp(&range, &bus->range[cookie]) == 0))
 		if (!kvm_iodevice_read(bus->range[cookie].dev, addr, len,
 				       val))
 			return cookie;
-- 
1.8.3.1


