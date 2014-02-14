Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaBNCiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:38:13 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:7403 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703AbaBNCiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:38:11 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <lars@metafoo.de>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <b47053@freescale.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH v3 1/3] ASoC: binding: add tdm-slot.txt
Date: Fri, 14 Feb 2014 09:34:34 +0800
Message-ID: <1392341676-4143-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1392341676-4143-1-git-send-email-Li.Xiubo@freescale.com>
References: <1392341676-4143-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@linaro.org>
---
 Documentation/devicetree/bindings/sound/tdm-slot.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/tdm-slot.txt

diff --git a/Documentation/devicetree/bindings/sound/tdm-slot.txt b/Documentation/devicetree/bindings/sound/tdm-slot.txt
new file mode 100644
index 0000000..6a2c842
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/tdm-slot.txt
@@ -0,0 +1,20 @@
+TDM slot:
+
+This specifies audio DAI's TDM slot.
+
+TDM slot properties:
+dai-tdm-slot-num : Number of slots in use.
+dai-tdm-slot-width :  Width in bits for each slot.
+
+For instance:
+	dai-tdm-slot-num = <2>;
+	dai-tdm-slot-width = <8>;
+
+And for each spcified driver, there could be one .of_xlate_tdm_slot_mask()
+to specify a explicit mapping of the channels and the slots. If it's absent
+the default snd_soc_of_xlate_tdm_slot_mask() will be used to generating the
+tx and rx masks.
+
+For snd_soc_of_xlate_tdm_slot_mask(), the tx and rx masks will use a 1 bit
+for an active slot as default, and the default active bits are at the LSB of
+the masks.
-- 
1.8.4


