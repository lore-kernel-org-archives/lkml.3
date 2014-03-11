Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaCKKk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:40:57 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:46570 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaCKKk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:40:56 -0400
X-Mailbox-Line: From bc0e25f6c042c8b99c8e83c6876ce0c8f7c3ab36 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1394533640.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 11 Mar 2014 11:27:20 +0100
Subject: [PATCH v2 0/4] ASoC: simple-card: DT fix and multi DAI links extension
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes a small problem about node device locks and also
extends the simple card driver to handle many DAI links as this exists
in the Cubox audio subsystem.

- v2
	- change subject/comment about device node reference count
		(Mark Brown)
	- use a null size array instead of an implicit area for the DAI links
		(Li Xiubo)
	- update the reference count of the device node at end of probe

Jean-Francois Moine (4):
  ASoC: simple-card: Fix the reference count of device nodes
  ASoC: simple-card: dynamically allocate the DAI link array
  ASoC: simple-card: accept many DAI links
  ASoC: simple-card: Add DT documentation for multi-DAI links

 .../devicetree/bindings/sound/simple-card.txt      |  34 +++-
 sound/soc/generic/simple-card.c                    | 174 ++++++++++++++-------
 2 files changed, 152 insertions(+), 56 deletions(-)

-- 
1.9.0

