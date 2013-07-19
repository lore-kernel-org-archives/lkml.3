Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027Ab3GSIsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:48:35 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:36454 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759869Ab3GSIsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:48:32 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-media@vger.kernel.org
Cc: alipowski@interia.pl, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, srinivas.kandagatla@gmail.com,
        srinivas.kandagatla@st.com, sean@mess.org
Subject: [PATCH v1 0/2] Allow rc device to open from lirc
Date: Fri, 19 Jul 2013 09:38:52 +0100
Message-Id: <1374223132-4924-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Thankyou for providing comments on RFC patch.

This patchset adds new members to rc_device structure to open rc device from
code other than rc-main. In the current code rc-device is only opened via input
driver. In cases where rc device is using lirc protocol, it will never be opened
as there is no input driver associated with lirc.

Thes patch set add fix to allow use cases like this to open rc device directly.

Thanks,
srini

Srinivas Kandagatla (2):
  media: rc: Add user count to rc dev.
  media: lirc: Allow lirc dev to talk to rc device

 drivers/media/rc/ir-lirc-codec.c |    1 +
 drivers/media/rc/lirc_dev.c      |   16 ++++++++++++++++
 drivers/media/rc/rc-main.c       |   11 +++++++++--
 include/media/lirc_dev.h         |    1 +
 include/media/rc-core.h          |    1 +
 5 files changed, 28 insertions(+), 2 deletions(-)

-- 
1.7.6.5

