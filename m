Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3DOCnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:43:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab3DOCnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 02/27] ASoC: core: Fix to check return value of snd_soc_update_bits_locked()
Date: Sun, 14 Apr 2013 19:43:01 -0700
Message-Id: <20130415024231.545985335@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonyoung Shim <jy0922.shim@samsung.com>

commit 0eaa6cca1f75e12e4f5ec62cbe887330fe3b5fe9 upstream.

It can be 0 or 1 return value of snd_soc_update_bits_locked() when it is
success. So just check return value is negative.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2959,7 +2959,7 @@ int snd_soc_put_volsw_range(struct snd_k
 	val = val << shift;
 
 	ret = snd_soc_update_bits_locked(codec, reg, val_mask, val);
-	if (ret != 0)
+	if (ret < 0)
 		return ret;
 
 	if (snd_soc_volsw_is_stereo(mc)) {


