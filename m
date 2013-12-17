Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3LQEQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 23:16:42 -0500
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:2428
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab3LQEQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 23:16:40 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <timur@tabi.org>,
        <perex@perex.cz>
CC: <r64188@freescale.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <tiwai@suse.de>, <grant.likely@linaro.org>,
        <fabio.estevam@freescale.com>, <LW@KARO-electronics.de>,
        <oskar@scara.com>, <shawn.guo@linaro.org>, <b42378@freescale.com>,
        <b18965@freescale.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <alsa-devel@alsa-project.org>
Subject: [PATCHv3 0/8] ALSA: Add SAI driver and enable SGT15000 codec
Date: Tue, 17 Dec 2013 11:24:37 +0800
Message-ID: <1387250684-23406-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series is mostly Freescale's SAI SoC Digital Audio Interface
driver implementation. And the implementation is only compatible with
device tree definition.

This patch series is based on linux-next and has been tested on Vybrid
VF610 Tower board using device tree.

Changed in v3:
- Add big-endian mode support.
- Revise some commit comments, coding styles,etc.
- Keep header files ordered by alphabet,etc.
- Add MODULE_ALIAS("platform:fsl-sai") for SAI driver.
- Rename the files to be in a same pattern with the existed ones.
- Remove some not useful functions or code.
- Only enable the clock while the device is in active use.
- Revise one error message according to Bill.

Changed in v2:
- Use default settings for the generic dmaengine PCM driver.
- Separate receive and transmit setting in most functions, but some couldn't for the HW limitation.
- Drop some not reduntant code.
- Use devm_snd_soc_register_component() instead of snd_soc_register_component().
- Use devm_snd_soc_register_card() instead of devm_snd_soc_register_card().
- Adjust the code sentences sequence.
- Make the namespacing consistent.
- Rename CONFIG_SND_SOC_FSL_SGTL5000 to CONFIG_SND_SOC_FSL_SGTL5000_VF610.
- Drop some meaningless lines.
- Rename the binding document file.

Added in v1:
- Add SAI SoC Digital Audio Interface driver.
- Add Freescale SAI ALSA SoC Digital Audio Interface node for VF610.
- Enables SAI ALSA SoC DAI device for Vybrid VF610 TOWER board.
- Add device tree bindings for Freescale SAI.
- Revise the bugs about the sgt15000 codec.
- Add SGT15000 based audio machine driver.
- Enable SGT15000 codec based audio driver node for VF610.
- Add device tree bindings for Freescale VF610 sound.





