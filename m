Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab3AOWrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:47:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:45119 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab3AOWq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:46:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 016/171] ASoC: sigmadsp: Fix endianness conversion issue
Date: Tue, 15 Jan 2013 14:43:01 -0800
Message-Id: <20130115224314.575247183@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit a3adb1432d7a3ad86bb17a1638e44414537e4118 upstream.

The 'addr' field of the sigma_action struct is stored as big endian in the
firmware file.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/sigmadsp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/sigmadsp.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -225,7 +225,7 @@ EXPORT_SYMBOL(process_sigma_firmware);
 static int sigma_action_write_regmap(void *control_data,
 	const struct sigma_action *sa, size_t len)
 {
-	return regmap_raw_write(control_data, le16_to_cpu(sa->addr),
+	return regmap_raw_write(control_data, be16_to_cpu(sa->addr),
 		sa->payload, len - 2);
 }
 


