Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab3LYRRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 12:17:50 -0500
Received: from mail-gg0-f180.google.com ([209.85.161.180]:36929 "EHLO
	mail-gg0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3LYRRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 12:17:49 -0500
Date: Wed, 25 Dec 2013 09:17:46 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, alan.cox@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, tiwai@suse.de, perex@perex.cz,
        alsa-devel@alsa-project.org
Subject: [PATCH 2/2] Use __compat_aligned_s64 in uapi <sound/asound.h>
Message-ID: <20131225171746.GA1826@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The integer64 field in struct snd_ctl_elem_value has different offsets,
depending the alignment of long long.  This patch replaces long long
with the newly introduced __compat_aligned_s64 so that x32 and ia32
can use the same compat system call for struct snd_ctl_elem_value.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 include/uapi/sound/asound.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/sound/asound.h b/include/uapi/sound/asound.h
index e3983d5..ea6489c 100644
--- a/include/uapi/sound/asound.h
+++ b/include/uapi/sound/asound.h
@@ -877,8 +877,8 @@ struct snd_ctl_elem_value {
 			long *value_ptr;	/* obsoleted */
 		} integer;
 		union {
-			long long value[64];
-			long long *value_ptr;	/* obsoleted */
+			__compat_aligned_s64 value[64];
+			__compat_aligned_s64 *value_ptr;	/* obsoleted */
 		} integer64;
 		union {
 			unsigned int item[128];
-- 
1.8.1.4

