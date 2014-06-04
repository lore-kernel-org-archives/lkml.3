Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbaFDXpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:45:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaFDXXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 3.10 032/103] drm/tegra: Remove gratuitous pad field
Date: Wed,  4 Jun 2014 16:24:55 -0700
Message-Id: <20140604232547.895885730@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

commit cbfbbabb89b37f6bad05f478d906a385149f288d upstream.

The version of the drm_tegra_submit structure that was merged all the
way back in 3.10 contains a pad field that was originally intended to
properly pad the following __u64 field. Unfortunately it seems like a
different field was dropped during review that caused this padding to
become unnecessary, but the pad field wasn't removed at that time.

One possible side-effect of this is that since the __u64 following the
pad is now no longer properly aligned, the compiler may (or may not)
introduce padding itself, which results in no predictable ABI.

Rectify this by removing the pad field so that all fields are again
naturally aligned. Technically this is breaking existing userspace ABI,
but given that there aren't any (released) userspace drivers that make
use of this yet, the fallout should be minimal.

Fixes: d43f81cbaf43 ("drm/tegra: Add gr2d device")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/drm/tegra_drm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/uapi/drm/tegra_drm.h
+++ b/include/uapi/drm/tegra_drm.h
@@ -103,7 +103,6 @@ struct drm_tegra_submit {
 	__u32 num_waitchks;
 	__u32 waitchk_mask;
 	__u32 timeout;
-	__u32 pad;
 	__u64 syncpts;
 	__u64 cmdbufs;
 	__u64 relocs;


