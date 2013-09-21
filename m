Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3IUPBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 11:01:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63646 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3IUPBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 11:01:16 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-cf-523db4bac962
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: m.chehab@samsung.com
Cc: t.stanislaws@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v5 0/4] media: s5p-tv: clean-up and fixes
Date: Sat, 21 Sep 2013 17:00:45 +0200
Message-id: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e+xoO6uLbZBBv+fyFhsnLGe1eJs0xt2
	i02Pr7FaXN41h82iZ8NWVouL6+QtTq85xWxx+E07q8X6Ga9ZLOa1v2R14PLYvKTe4+C7PUwe
	fVtWMXp83iQXwBLFZZOSmpNZllqkb5fAlTHj1i6mgjXsFZefsTQwvmftYuTkkBAwkZgz7T87
	hC0mceHeerYuRi4OIYHpjBIfmyZCOe1MEs8nNjCCVLEJmEtMfLaJBcQWEZCQuL/6GVgRs8B0
	JomtH7rBxgoLWEpc/t0K1sAioCrxuOEDmM0r4Cvx78FPNoh1ChI/L59gm8DIvYCRYRWjaGpB
	ckFxUnquoV5xYm5xaV66XnJ+7iZGcNg8k9rBuLLB4hCjAAejEg9vRpJtkBBrYllxZe4hRgkO
	ZiURXvlUoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQZG
	Byn2Uqc2fouwZ3ei7uyR27ardlL7rj2XT2vktRsmHF/M1tbZIyuq43KJy0y3xZxxyaN6dsVj
	9zK9zdnmfztyqX9T54S8TV7TWsPDDn89EhzJ9X/WkZxyycivtwK6jM8kB89IXF/JLPLmwK9P
	Dv94rq/d5XUhpNEvVfBfrnVw7k6OibGnDz1RYinOSDTUYi4qTgQAqY3h5BcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add restoring previous vpll rate after driver offs stream 
or recives error.
It also replace mxr_info, mxr_dbg, mxr_warn and mxr_err macro 
by generic solution.

Mateusz Krawczuk (4):
  media: s5p-tv: Replace mxr_ macro by default dev_
  media: s5p-tv: Restore vpll clock rate
  media: s5p-tv: Fix sdo driver to work with CCF
  media: s5p-tv: Fix mixer driver to work with CCF

 drivers/media/platform/s5p-tv/mixer.h           |  12 ---
 drivers/media/platform/s5p-tv/mixer_drv.c       |  81 ++++++++++++-------
 drivers/media/platform/s5p-tv/mixer_grp_layer.c |   2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c       |   6 +-
 drivers/media/platform/s5p-tv/mixer_video.c     | 100 ++++++++++++------------
 drivers/media/platform/s5p-tv/mixer_vp_layer.c  |   2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c         |  39 +++++++--
 7 files changed, 137 insertions(+), 105 deletions(-)

-- 
1.8.1.2

