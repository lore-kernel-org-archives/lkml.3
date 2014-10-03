Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaJCVd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:33:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbaJCVdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:33:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Andersen <martin.x.andersen@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.16 078/357] drm/i915/hdmi: fix hdmi audio state readout
Date: Fri,  3 Oct 2014 14:27:44 -0700
Message-Id: <20141003212935.832839180@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit c84db77010877da6c5da119868ed54c43d59e726 upstream.

Check the correct bit for audio. Seems like a copy-paste error from the
start:

commit 9ed109a7b445e3f073d8ea72f888ec80c0532465
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Apr 24 23:54:52 2014 +0200

    drm/i915: Track has_audio in the pipe config

Reported-by: Martin Andersen <martin.x.andersen@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=82756
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -728,7 +728,7 @@ static void intel_hdmi_get_config(struct
 	if (tmp & HDMI_MODE_SELECT_HDMI)
 		pipe_config->has_hdmi_sink = true;
 
-	if (tmp & HDMI_MODE_SELECT_HDMI)
+	if (tmp & SDVO_AUDIO_ENABLE)
 		pipe_config->has_audio = true;
 
 	pipe_config->adjusted_mode.flags |= flags;


