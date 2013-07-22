Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3GVIcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:32:45 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:39897 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756738Ab3GVIcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:32:41 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-media@vger.kernel.org
Cc: alipowski@interia.pl, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@gmail.com,
        srinivas.kandagatla@st.com, sean@mess.org
Subject: [PATCH v2 0/2] Allow rc device to open from lirc
Date: Mon, 22 Jul 2013 09:21:59 +0100
Message-Id: <1374481319-3293-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Thankyou for providing comments on v1 patch.

This patchset adds new members to rc_device structure to open rc device from
code other than rc-main. In the current code rc-device is only opened via input
driver. In cases where rc device is using lirc protocol, it will never be opened
as there is no input driver associated with lirc.

Thes patch set add fix to allow use cases like this to open rc device directly.

Changes since v1:
	- used rcdev->lock around increments and decrements of users pointed by
	  Sean Young.
	- Common up code in rc_open/rc_close.


Thanks,
srini

Srinivas Kandagatla (2):
  media: rc: Add rc_open/close and use count to rc_dev.
  media: lirc: Allow lirc dev to talk to rc device

 drivers/media/rc/ir-lirc-codec.c |    1 +
 drivers/media/rc/lirc_dev.c      |   10 ++++++++
 drivers/media/rc/rc-main.c       |   46 ++++++++++++++++++++++++++++++++++---
 include/media/lirc_dev.h         |    1 +
 include/media/rc-core.h          |    4 +++
 5 files changed, 58 insertions(+), 4 deletions(-)

-- 
1.7.6.5

