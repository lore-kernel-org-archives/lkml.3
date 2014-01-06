Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbaAFWj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:39:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbaAFWjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.12 093/144] powerpc: Align p_end
Date: Mon,  6 Jan 2014 14:37:34 -0800
Message-Id: <20140106223748.028379072@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 286e4f90a72c0b0621dde0294af6ed4b0baddabb upstream.

p_end is an 8 byte value embedded in the text section. This means it
is only 4 byte aligned when it should be 8 byte aligned. Fix this
by adding an explicit alignment.

This fixes an issue where POWER7 little endian builds with
CONFIG_RELOCATABLE=y fail to boot.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_64.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -467,6 +467,7 @@ _STATIC(__after_prom_start)
 	mtctr	r8
 	bctr
 
+.balign 8
 p_end:	.llong	_end - _stext
 
 4:	/* Now copy the rest of the kernel up to _end */


