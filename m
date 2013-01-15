Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab3AOW3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:29:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:41839 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab3AOW3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:29:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Subject: [ 075/221] drm/radeon: add WAIT_UNTIL to evergreen VM safe reg list
Date: Tue, 15 Jan 2013 10:50:02 -0800
Message-Id: <20130115185003.478996545@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 668bbc81baf0f34df832d8aca5c7d5e19a493c68 upstream.

It's used in a recent mesa commit:
http://cgit.freedesktop.org/mesa/mesa/commit/?id=24b1206ab2dcd506aaac3ef656aebc8bc20cd27a
and there may be some other cases in the future where it's required.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen_cs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -2724,6 +2724,7 @@ static bool evergreen_vm_reg_valid(u32 r
 
 	/* check config regs */
 	switch (reg) {
+	case WAIT_UNTIL:
 	case GRBM_GFX_INDEX:
 	case CP_STRMOUT_CNTL:
 	case CP_COHER_CNTL:


