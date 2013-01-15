Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab3AOWcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:32:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:42799 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758446Ab3AOWc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@ingics.com>, Rajeev Kumar <rajeev-dlh.kumar@st.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 129/221] ASoC: sta529: Fix update register bits in sta529_set_dai_fmt
Date: Tue, 15 Jan 2013 10:50:56 -0800
Message-Id: <20130115185007.344170381@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit ad1937cdd59c412097ec2bb8f38c12a5640f1f9a upstream.

Both the mask and mode settings are wrong in current code.

According to the datasheet:

S2PCFG0 (0x0A)
BIT[3:1] DATA_FORMAT
        serial interface protocol format:
        000: left Justified
        001: I2S (default)
        010: right justified
        100: PCM no delay
        101: PCM delay
        111: DSP

Thus fixes the defines for LEFT_J_DATA_FORMAT, I2S_DATA_FORMAT, and
RIGHT_J_DATA_FORMAT.
Also adds define for DATA_FORMAT_MSK.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/sta529.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/sta529.c
+++ b/sound/soc/codecs/sta529.c
@@ -74,9 +74,10 @@
 				SNDRV_PCM_FMTBIT_S32_LE)
 #define	S2PC_VALUE		0x98
 #define CLOCK_OUT		0x60
-#define LEFT_J_DATA_FORMAT	0x10
-#define I2S_DATA_FORMAT		0x12
-#define RIGHT_J_DATA_FORMAT	0x14
+#define DATA_FORMAT_MSK		0x0E
+#define LEFT_J_DATA_FORMAT	0x00
+#define I2S_DATA_FORMAT		0x02
+#define RIGHT_J_DATA_FORMAT	0x04
 #define CODEC_MUTE_VAL		0x80
 
 #define POWER_CNTLMSAK		0x40
@@ -289,7 +290,7 @@ static int sta529_set_dai_fmt(struct snd
 		return -EINVAL;
 	}
 
-	snd_soc_update_bits(codec, STA529_S2PCFG0, 0x0D, mode);
+	snd_soc_update_bits(codec, STA529_S2PCFG0, DATA_FORMAT_MSK, mode);
 
 	return 0;
 }


