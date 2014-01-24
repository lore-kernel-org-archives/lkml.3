Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaAXGDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 01:03:41 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:28380
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbaAXGDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 01:03:10 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Liu Ying <Ying.Liu@freescale.com>
To: <jg1.han@samsung.com>
CC: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <jani.nikula@linux.intel.com>
Subject: [PATCH v4 0/2] backlight: update bl status and some bd properties when necessary
Date: Fri, 24 Jan 2014 14:04:34 +0800
Message-ID: <1390543476-13499-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have to turn backlight on/off every time a blanking
or unblanking event comes because the backlight status may
have already been what we want. Another thought is that one
backlight device may be shared by multiple framebuffers. We
don't hope blanking one of the framebuffers may turn the
backlight off for all the other framebuffers, since they are
likely being active to display something. This patch set adds
some logics to record each framebuffer's backlight usage to
determine the backlight device use count and whether the
backlight status should be updated or not.

Liu Ying (2):
  backlight: update bd state & fb_blank properties when necessary
  backlight: update backlight status when necessary

v3->v4:
* Split v3 into 2 patches to separate the change for updating the
  backlight device properties and backlight status, according to
  the comments from Jani Nikula and Jingoo Han.

v2->v3:
* Set fb_blank(*(int *)evdata->data) to bd->props.fb_blank
  when we turn off a blacklight.
* Correct some trivial typos in the commit message.

v1->v2:
* Make the commit message be more specific about the condition
  in which backlight device use count can be increased/decreased.
* Correct the setting for bd->props.fb_blank.

 drivers/video/backlight/backlight.c |   28 +++++++++++++++++++++-------
 include/linux/backlight.h           |    6 ++++++
 2 files changed, 27 insertions(+), 7 deletions(-)

-- 
1.7.9.5


