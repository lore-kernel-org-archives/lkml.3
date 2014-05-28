Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaE1VrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:47:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37942 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbaE1VrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:47:23 -0400
From: Nishanth Menon <nm@ti.com>
To: <dbaryshkov@gmail.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <linux@arm.linux.org.uk>, <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 0/2] power: twl4030_charger: cleanup to handle various battery handling error conditions
Date: Wed, 28 May 2014 16:46:48 -0500
Message-ID: <1401313610-14252-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This issue was originally reported by Russell on OMAP3-LDP platform,
and original attempt to solve this by Felipe[1] did not quiet work,
follow on attempt[2] seems to be effective, but in this resend, I have
added an shutdown attempt in case things dont quiet look right.

Based on: v3.15-rc7

Tests:
ldp boot with battery: http://slexy.org/raw/s20StiV4xr
ldp boot with a/c charger, no battery: http://slexy.org/raw/s2UfjIkZKG
ldp boot with a/c charger+battery, remove battery: http://slexy.org/raw/s2yFTVlrWJ
	^^ <- this is not exactly a safe test to perform :)..

Nishanth Menon (2):
  power: twl4030_charger: detect battery presence prior to enabling    
    charger
  power: twl4030_charger: attempt to power off in case of critical
    events

 drivers/power/twl4030_charger.c |   70 +++++++++++++++++++++++++++++++++++----
 1 file changed, 64 insertions(+), 6 deletions(-)

[1] https://patchwork.kernel.org/patch/4002371/
[2] https://patchwork.kernel.org/patch/4124751/
-- 
1.7.9.5

