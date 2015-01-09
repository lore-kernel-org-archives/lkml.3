Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbbAIPDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:03:47 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40823 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752182AbbAIPDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:03:46 -0500
Date: Fri, 9 Jan 2015 16:03:42 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [GIT PULL] drm: Add Atmel HLCDC driver
Message-ID: <20150109160342.715d3592@bbrezillon>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, Thierry,

Here is the pull request for the Atmel HLCDC driver and its
dependencies (some modifications to drm/core and drm/panel to define
output bus format).

I'm sending a pull request for this driver for several reasons:

 * The patch series has been around for 6 months (initial version here
   [3]), and has seen 9 iterations, taking into account comments made
   by reviewers.

 * It has received several Tested-by by various users/developers.

 * It has been Reviewed-by Rob Clark.

 * There has been no comment whatsoever since more than a month (see
   [1] and [2] for the last modified version of these series).

I'll be happy to take comments into account if any. But if there are no
more comments, please merge for 3.20.

Best Regards,

Boris

[1]https://lkml.org/lkml/2014/12/1/717
[2]http://thread.gmane.org/gmane.comp.video.dri.devel/118700
[3]https://lkml.org/lkml/2014/6/9/487

The following changes since commit c93546a5e32bd788c22aefa072385f3784551c13:

  Merge tag 'topic/atomic-core-2015-01-05' of git://anongit.freedesktop.org/drm-intel into drm-next (2015-01-09 09:22:40 +1000)

are available in the git repository at:


  https://github.com/bbrezillon/linux-at91.git tags/atmel-hlcdc-drm-3.20

for you to fetch changes up to e7f6614add3dc7776abd803be7cbe96b6254b3f5:

  drm: add DT bindings documentation for atmel-hlcdc-dc driver (2015-01-09 14:55:08 +0100)

----------------------------------------------------------------
Boris Brezillon (5):
      drm: add bus_formats and num_bus_formats fields to drm_display_info
      drm: panel: simple-panel: add support for bus_format retrieval
      drm: panel: simple-panel: add bus format information for foxlink panel
      drm: add Atmel HLCDC Display Controller support
      drm: add DT bindings documentation for atmel-hlcdc-dc driver

 .../devicetree/bindings/drm/atmel/hlcdc-dc.txt     |  53 ++
 drivers/gpu/drm/Kconfig                            |   2 +
 drivers/gpu/drm/Makefile                           |   1 +
 drivers/gpu/drm/atmel-hlcdc/Kconfig                |  11 +
 drivers/gpu/drm/atmel-hlcdc/Makefile               |   7 +
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     | 406 ++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c       | 579 ++++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h       | 213 +++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c    | 667 ++++++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h    | 398 ++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c   | 319 ++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c    | 856 +++++++++++++++++++++
 drivers/gpu/drm/drm_crtc.c                         |  35 +
 drivers/gpu/drm/panel/panel-simple.c               |   6 +
 include/drm/drm_crtc.h                             |   8 +
 15 files changed, 3561 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/drm/atmel/hlcdc-dc.txt
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/Kconfig
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/Makefile
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
