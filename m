Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbaCDUEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaCDUEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 167/172] drm/radeon: print the supported atpx function mask
Date: Tue,  4 Mar 2014 12:04:11 -0800
Message-Id: <20140304200305.046376830@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 9f050c7f9738ffa746c63415136645ad231b1348 upstream.

Print the supported functions mask in addition to
the version.  This is useful in debugging PX
problems since we can see what functions are available.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -219,7 +219,8 @@ static int radeon_atpx_verify_interface(
 	memcpy(&output, info->buffer.pointer, size);
 
 	/* TODO: check version? */
-	printk("ATPX version %u\n", output.version);
+	printk("ATPX version %u, functions 0x%08x\n",
+	       output.version, output.function_bits);
 
 	radeon_atpx_parse_functions(&atpx->functions, output.function_bits);
 


