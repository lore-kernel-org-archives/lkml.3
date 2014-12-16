Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaLPOK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:10:59 -0500
Received: from c-82-192-226-27.customer.ggaweb.ch ([82.192.226.27]:35220 "EHLO
	dizzy-6.o2s.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751035AbaLPOK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:10:57 -0500
Subject: [PATCH 0/4] mmc: sunxi: General fixup (v2)
From: David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        Peter Griffin <peter.griffin@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>,
        =?utf-8?b?5p2O5oOz?= <lixiang@allwinnertech.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 16 Dec 2014 15:10:54 +0100
Message-ID: <20141216140921.3036.14668.stgit@dizzy-6.o2s.ch>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello
This patchset was inspired questions from 李想 of Allwinner and incorporates as
well suggestions from Hans related to spin locks.
For example have not all attributes of the shared host object been protected
by the spin lock, this has been changed.
Also some register names and reset behavior have been fixed now.
And a minor cleanup happened at the clock frequecy setting, since there has
been a piece of left over code which has been there because it was in the Android
driver and we just adapted it because we didn't have proper documentation about
the timing of the module.

Looking forward to your feedback
Cheers David

---

David Lanzendörfer (3):
      mmc: sunxi: Lock fix
      mmc: sunxi: Correcting SDXC_HARDWARE_RESET bit
      mmc: sunxi: Removing unused code

Hans de Goede (1):
      mmc: sunxi: Fix setup of last descriptor of dma transfer


 drivers/mmc/host/sunxi-mmc.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--
Signature
