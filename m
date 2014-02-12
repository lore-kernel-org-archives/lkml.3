Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaBLIsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:48:41 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:57741
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbaBLIsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:48:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <tiwai@suse.de>, <perex@perex.cz>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 1/3] ASoC: binding: add tdm-slot.txt
Date: Wed, 12 Feb 2014 15:45:10 +0800
Message-ID: <1392191112-27028-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1392191112-27028-1-git-send-email-Li.Xiubo@freescale.com>
References: <1392191112-27028-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TDM slot:

This specifies audio DAI's TDM slot.

Each entry is has four non-negative integer values in DT:
       <tx_mask, rx_mask, slots, slot_width>

For instance:
       simple-slot-info = <0xffffffc 0xffffffc 2 0>;

And this will be parsed into the following format:
       struct soc_slot_info {
              unsigned int tx_mask;
              unsigned int rx_mask;
              int slots;
              int slot_width;
       };

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 Documentation/devicetree/bindings/sound/tdm-slot.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/tdm-slot.txt

diff --git a/Documentation/devicetree/bindings/sound/tdm-slot.txt b/Documentation/devicetree/bindings/sound/tdm-slot.txt
new file mode 100644
index 0000000..33dfb15
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/tdm-slot.txt
@@ -0,0 +1,17 @@
+TDM slot:
+
+This specifies audio DAI's TDM slot.
+
+Each entry is has four non-negative integer values in DT:
+	<tx_mask, rx_mask, slots, slot_width>
+
+For instance:
+	simple-slot-info = <0xffffffc 0xffffffc 2 0>;
+
+And this will be parsed into the following format:
+	struct soc_slot_info {
+	       unsigned int tx_mask;
+	       unsigned int rx_mask;
+	       int slots;
+	       int slot_width;
+	};
-- 
1.8.4


