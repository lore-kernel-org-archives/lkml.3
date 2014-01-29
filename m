Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaA2QZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:25:17 -0500
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:57168 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402AbaA2QZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:25:12 -0500
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com
Subject: [PATCH 0/3] CCF clock divider changes
Date: Wed, 29 Jan 2014 17:24:05 +0100
Message-Id: <1391012648-12481-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

First patch fixes round_rate for power-of-two and table-based dividers when
the CLK_SET_RATE_PARENT flag isn't set.

Second patch introduces a new flag to give the possibility to round the
divider to the closest one, instead of rounding up by default.

Third patch optimizes the for-loop when CLK_SET_RATE_PARENT is set for
power-of-two and table-based dividers.

The series applies on top of v3.13 tag.

Maxime Coquelin (3):
  clk: divider: Fix best div calculation for power-of-two and table
    dividers
  clk: divider: Add round to closest divider
  clk: divider: Optimize clk_divider_bestdiv loop

 drivers/clk/clk-divider.c    |  118 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/clk-provider.h |    3 ++
 2 files changed, 118 insertions(+), 3 deletions(-)

-- 
1.7.9.5

