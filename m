Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbbATJDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:03:49 -0500
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30229 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbATJDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:03:45 -0500
X-IronPort-AV: E=McAfee;i="5600,1067,7686"; a="82585021"
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="25708901"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: David Miller <davem@davemloft.net>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: pull-request: wireless-drivers 2015-01-20
Date: Tue, 20 Jan 2015 11:03:33 +0200
Message-ID: <87oapt3jtm.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: NASANEXM01C.na.qualcomm.com (10.85.0.83) To
 NALASEXR01G.na.qualcomm.com (10.49.56.53)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

more fixes for 3.19, I hope these are still appropriate. Please let me
know if there are any issues.

Kalle

The following changes since commit 16dde0d6ac159531a5e03cd3f8bc8a401d9f3fb6:

  be2net: Allow GRE to work concurrently while a VxLAN tunnel is configured (2015-01-15 01:55:05 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2015-01-20

for you to fetch changes up to e3f31175a3eeb492a6ab788e4fa136c19b43aab4:

  ath9k: fix race condition in irq processing during hardware reset (2015-01-19 14:32:29 +0200)

----------------------------------------------------------------
ath9k:

* fix an IRQ storm caused by commit 872b5d814f99

iwlwifi:

* A fix for scan that fixes a firmware assertion

* A fix that improves roaming behavior. Same fix has been tested for
  a while in iwldvm. This is a bit of a work around, but the real fix
  should be in mac80211 and will come later.

* A fix for BARs that avoids a WARNING.

* one fix for rfkill while scheduled scan is running.
  Linus's system hit this issue. WiFi would be unavailable
  after this has happpened because of bad state in cfg80211.

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: mvm: fix EBS on single scan

Emmanuel Grumbach (2):
      iwlwifi: mvm: drop non VO frames when flushing
      iwlwifi: mvm: abort scheduled scan upon RFKILL

Eyal Shapira (1):
      iwlwifi: mvm: set the tx cmd tid for BAR frame correctly

Felix Fietkau (1):
      ath9k: fix race condition in irq processing during hardware reset

Kalle Valo (2):
      Merge tag 'iwlwifi-for-kalle-2015-01-13' of https://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge tag 'iwlwifi-for-kalle-2015-01-15' of https://git.kernel.org/.../iwlwifi/iwlwifi-fixes

 drivers/net/wireless/ath/ath9k/main.c          |    7 ++--
 drivers/net/wireless/iwlwifi/iwl-fw-file.h     |    2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |    7 +++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |   20 ++++-----
 drivers/net/wireless/iwlwifi/mvm/scan.c        |   53 ++++++++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/tx.c          |   11 ++++-
 6 files changed, 69 insertions(+), 31 deletions(-)

-- 
Kalle Valo
