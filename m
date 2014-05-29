Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaE2EfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbaE2EfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 3.14 061/140] drm/radeon: fix endian swap on hawaii clear state buffer setup
Date: Wed, 28 May 2014 21:33:20 -0700
Message-Id: <20140529043057.326649149@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit a8947f576728a66bd3aac629bd8ca021a010c808 upstream.

Need to swap on BE.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -6521,8 +6521,8 @@ void cik_get_csb_buffer(struct radeon_de
 		buffer[count++] = cpu_to_le32(0x00000000);
 		break;
 	case CHIP_HAWAII:
-		buffer[count++] = 0x3a00161a;
-		buffer[count++] = 0x0000002e;
+		buffer[count++] = cpu_to_le32(0x3a00161a);
+		buffer[count++] = cpu_to_le32(0x0000002e);
 		break;
 	default:
 		buffer[count++] = cpu_to_le32(0x00000000);


