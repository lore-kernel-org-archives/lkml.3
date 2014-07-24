Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046AbaGXQCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:02:24 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:38685 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933642AbaGXQCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:02:20 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, olebowle@gmx.com, dheitmueller@kernellabs.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] dvb-core and drx39xyj - add resume support
Date: Thu, 24 Jul 2014 10:02:13 -0600
Message-Id: <cover.1406215947.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some fe drivers will have to do additional initialization
in their fe ops.init interfaces when called during resume.
Without the additional initialization, fe and tuner driver
resume fails. A new fe exit flag value DVB_FE_DEVICE_RESUME
is necessary to detect resume case.

This patch series adds: 

- a new define and changes dvb_frontend_resume() to set it
  prior to calling fe init and tuner init calls and resets
  it back to DVB_FE_NO_EXIT once fe and tuner init is done.

- drx39xyj driver lacks resume support. Add support by changing
  its fe ops init interface to detect the resume status by checking
  fe exit flag and do the necessary initialization. With this change,
  driver resume correctly in both dvb adapter is not in use and in use
  by an application cases.

- The first patch depends on a previous patch that moved
  fe exit flag from fepriv to fe for driver access

https://lkml.org/lkml/2014/7/12/115

Shuah Khan (2):
  media: dvb-core add new flag exit flag value for resume
  media: drx39xyj - add resume support

 drivers/media/dvb-core/dvb_frontend.c       |    2 +
 drivers/media/dvb-core/dvb_frontend.h       |    1 +
 drivers/media/dvb-frontends/drx39xyj/drxj.c |   65 +++++++++++++++++----------
 3 files changed, 45 insertions(+), 23 deletions(-)

-- 
1.7.10.4

