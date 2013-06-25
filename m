Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab3FYMzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:55:09 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60302 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab3FYMzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:55:06 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/4] Fix more issues with generic pinconf bindings
Date: Tue, 25 Jun 2013 14:55:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306251455.01540.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Stephen Warren pointed out, some pinconf bindings had deficits
either in documentation or in the whole thought process.

Therefore this series tries to fix these issues by improving
documentation and removing the real controversial bindings for now.

Of the changed pinconf bindings only the slew-rate had an acutal
current user (since yesterday). James I hope it's ok to simply
remove the slew-rate handling from the tz1090 driver until we can
handle it correctly in dt.


Heiko Stuebner (4):
  pinctrl: more clarifications for generic pull configs
  pinctrl: set unit for debounce time pinconfig to usec
  pinctrl: remove slew-rate parameter from tz1090
  pinctrl: remove bindings for pinconf options needing more thought

 .../bindings/pinctrl/img,tz1090-pdc-pinctrl.txt      |    5 +----
 .../bindings/pinctrl/img,tz1090-pinctrl.txt          |    7 +------
 .../devicetree/bindings/pinctrl/pinctrl-bindings.txt |   18 ++++--------------
 drivers/pinctrl/pinconf-generic.c                    |    5 +----
 drivers/pinctrl/pinctrl-tz1090-pdc.c                 |    5 -----
 drivers/pinctrl/pinctrl-tz1090.c                     |    5 -----
 include/linux/pinctrl/pinconf-generic.h              |    7 +++++--
 7 files changed, 12 insertions(+), 40 deletions(-)

-- 
1.7.10.4

