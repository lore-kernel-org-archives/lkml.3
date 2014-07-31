Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaGaLz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:55:58 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59601 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaGaLz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:55:56 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 0/2] Better model Peach Pit and PI power scheme
Date: Thu, 31 Jul 2014 13:55:09 +0200
Message-Id: <1406807711-19955-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a small series that improve the modeling of the power
scheme on the Peach Pit and Pi boards. Besides making the DTS
to better describe the hardware these changes allows the core
regulator to know what's the real supply for a child to fetch
the parent output voltage if the child voltage is requested,
now that the regulator core allows to do that [0,1].

Patch 1 modifies the regulators input supply to use the real
parents instead of using a simplistic model and assume that
VDC is supplying power to all regulators and patch 2 defines
the maximum and minimum voltage constraints for the switches.

Javier Martinez Canillas (2):
  ARM: dts: Improve Peach Pit and Pi power scheme model
  ARM: dts: Add tps65090 FET constraints on Peach Pit and Pi

 arch/arm/boot/dts/exynos5420-peach-pit.dts | 26 ++++++++++++++++++++------
 arch/arm/boot/dts/exynos5800-peach-pi.dts  | 26 ++++++++++++++++++++------
 2 files changed, 40 insertions(+), 12 deletions(-)

Best regards,
Javier

[0]: https://patchwork.kernel.org/patch/4641331/
[1]: https://patchwork.kernel.org/patch/4641311/
