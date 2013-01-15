Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab3AOXoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:44:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:46073 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933108Ab3AOWug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 071/171] ASoC: wm2000: Fix sense of speech clarity enable
Date: Tue, 15 Jan 2013 14:43:56 -0800
Message-Id: <20130115224318.512554823@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 267f8fa2e1eef0612b2007e1f1846bcbc35cc1fa upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm2000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -190,9 +190,9 @@ static int wm2000_power_up(struct i2c_cl
 
 	ret = wm2000_read(i2c, WM2000_REG_SPEECH_CLARITY);
 	if (wm2000->speech_clarity)
-		ret &= ~WM2000_SPEECH_CLARITY;
-	else
 		ret |= WM2000_SPEECH_CLARITY;
+	else
+		ret &= ~WM2000_SPEECH_CLARITY;
 	wm2000_write(i2c, WM2000_REG_SPEECH_CLARITY, ret);
 
 	wm2000_write(i2c, WM2000_REG_SYS_START0, 0x33);


