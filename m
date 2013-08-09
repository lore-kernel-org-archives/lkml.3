Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967567Ab3HICV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:21:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967387Ab3HIB6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Ivanov <gnidorah@p0n4ik.tk>, Helge Deller <deller@gmx.de>
Subject: [ 016/102] parisc: agp/parisc-agp: allow binding of user memory to the AGP GART
Date: Thu,  8 Aug 2013 18:56:52 -0700
Message-Id: <20130809015013.921926166@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Ivanov <gnidorah@p0n4ik.tk>

commit 06f0cce43a32bd2357cea1d8733bba48693d556b upstream.

Allow binding of user memory to the AGP GART on systems with HP
Quicksilver AGP bus. This resolves 'bind memory failed' error seen in
dmesg:

 [29.365973] [TTM] AGP Bind memory failed.
 …
 [29.367030] [drm] Forcing AGP to PCI mode

The system doesn't more fail to bind the memory, and hence not falling
back to the PCI mode (if other failures aren't detected).

This is just a simple write down from the following patches:
agp/amd-k7: Allow binding user memory to the AGP GART
agp/hp-agp: Allow binding user memory to the AGP GART

Signed-off-by: Alex Ivanov <gnidorah@p0n4ik.tk>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/agp/parisc-agp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/char/agp/parisc-agp.c
+++ b/drivers/char/agp/parisc-agp.c
@@ -129,7 +129,8 @@ parisc_agp_insert_memory(struct agp_memo
 	off_t j, io_pg_start;
 	int io_pg_count;
 
-	if (type != 0 || mem->type != 0) {
+	if (type != mem->type ||
+		agp_bridge->driver->agp_type_to_mask_type(agp_bridge, type)) {
 		return -EINVAL;
 	}
 
@@ -175,7 +176,8 @@ parisc_agp_remove_memory(struct agp_memo
 	struct _parisc_agp_info *info = &parisc_agp_info;
 	int i, io_pg_start, io_pg_count;
 
-	if (type != 0 || mem->type != 0) {
+	if (type != mem->type ||
+		agp_bridge->driver->agp_type_to_mask_type(agp_bridge, type)) {
 		return -EINVAL;
 	}
 


