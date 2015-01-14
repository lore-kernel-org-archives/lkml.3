Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbbANHi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:38:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbbANHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:38:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 08/44] ASoC: sigmadsp: Refuse to load firmware files with a non-supported version
Date: Tue, 13 Jan 2015 23:23:29 -0800
Message-Id: <20150114072227.922122751@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072227.419663002@linuxfoundation.org>
References: <20150114072227.419663002@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 50c0f21b42dd4cd02b51f82274f66912d9a7fa32 upstream.

Make sure to check the version field of the firmware header to make sure to
not accidentally try to parse a firmware file with a different layout.
Trying to do so can result in loading invalid firmware code to the device.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/sigmadsp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/codecs/sigmadsp.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -176,6 +176,13 @@ static int _process_sigma_firmware(struc
 		goto done;
 	}
 
+	if (ssfw_head->version != 1) {
+		dev_err(dev,
+			"Failed to load firmware: Invalid version %d. Supported firmware versions: 1\n",
+			ssfw_head->version);
+		goto done;
+	}
+
 	crc = crc32(0, fw->data + sizeof(*ssfw_head),
 			fw->size - sizeof(*ssfw_head));
 	pr_debug("%s: crc=%x\n", __func__, crc);


