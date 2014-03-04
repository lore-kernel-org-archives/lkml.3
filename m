Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbaCDUm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:42:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbaCDUEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.13 171/172] drm/i915/dp: increase native aux defer retry timeout
Date: Tue,  4 Mar 2014 12:04:15 -0800
Message-Id: <20140304200305.164674237@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

commit 04eada25d1f72efdecd32d702706594f81de65d5 upstream.

Give more slack to sink devices before retrying on native aux
defer. AFAICT the 100 us timeout was not based on the DP spec.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: stable@vger.kernel.org (on Jani's request)
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -555,7 +555,7 @@ intel_dp_aux_native_write(struct intel_d
 		if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
 			break;
 		else if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
-			udelay(100);
+			usleep_range(400, 500);
 		else
 			return -EIO;
 	}
@@ -607,7 +607,7 @@ intel_dp_aux_native_read(struct intel_dp
 			return ret - 1;
 		}
 		else if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
-			udelay(100);
+			usleep_range(400, 500);
 		else
 			return -EIO;
 	}


