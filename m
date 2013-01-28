Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3A1PzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:55:01 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1924 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3A1Py7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:54:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 28 Jan 2013 07:54:55 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Table lookup for mux clock type
Date: Mon, 28 Jan 2013 17:54:20 +0200
Message-ID: <1359388467-32386-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a table lookup feature to the mux clock type. This will
be used by the forthcoming Tegra114 clock implementation. Also instead of
a fixed field width, a mask is used. This is because Tegra114 has some muxes
where the parent selector is spread over several bitfields. The second patch
adapts the tegra periph clock implementation which uses struct clk_mux
directly.

Peter De Schrijver (2):
  clk: add table lookup to mux
  clk: tegra: adapt tegra periph clk to mux table/mask

 drivers/clk/clk-mux.c        |   51 ++++++++++++++++++++++++++++++++---------
 drivers/clk/tegra/clk.h      |   27 +++++++++++++++------
 include/linux/clk-private.h  |    3 +-
 include/linux/clk-provider.h |    9 ++++++-
 4 files changed, 69 insertions(+), 21 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

