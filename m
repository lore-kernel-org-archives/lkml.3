Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaCOLlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 07:41:49 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:47309 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaCOLls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 07:41:48 -0400
X-Mailbox-Line: From d054780a0edf4b2338a52e48bff9144e19aa614f Mon Sep 17 00:00:00 2001
Message-Id: <cover.1394883134.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 15 Mar 2014 12:32:14 +0100
Subject: [PATCH v3 0/4] ASoC: simple-card: multi DAI links extension
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series extends the simple card driver to handle
many DAI links as this exists in the Cubox audio subsystem.

-v3
	- remove 'Fix the reference count of device nodes'
		which is applied (Mark Brown)
	- new patch 'Simplify code'
	- dynamically allocate and use properties for all DAI links
		(Jyri Sarha and Li Xiubo)
- v2
	- change subject/comment about device node reference count
		(Mark Brown)
	- use a null size array instead of an implicit area for the DAI links
		(Li Xiubo)
	- update the reference count of the device node at end of probe

Jean-Francois Moine (4):
  ASoC: simple-card: Simplify code
  ASoC: simple-card: dynamically allocate the DAI link and properties
  ASoC: simple-card: Handle many DAI links
  ASoC: simple-card: Add DT documentation for multi-DAI links

 .../devicetree/bindings/sound/simple-card.txt      |  34 +++-
 sound/soc/generic/simple-card.c                    | 181 +++++++++++++--------
 2 files changed, 145 insertions(+), 70 deletions(-)

-- 
1.9.0

