Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaHNBJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:09:31 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:53201
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149AbaHNBJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:09:29 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, fabf@skynet.be
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] media: tuner xc5000 firmware load fixes and improvements
Date: Wed, 13 Aug 2014 19:09:22 -0600
Message-Id: <cover.1407977791.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes firmware load issues seen during suspend and
resume and speeds up firmware force load path. Releasing
firmware from xc5000_release() instead of right after load
helps avoid requesting firmware when it needs to be force
loaded and fixes slowpath warnings during resume after suspend
is done before firmware is loaded.

Shuah Khan (2):
  media: tuner xc5000 - release firmwware from xc5000_release()
  media: tuner xc5000 - try to avoid firmware load in resume path

 drivers/media/tuners/xc5000.c |   50 ++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 15 deletions(-)

-- 
1.7.10.4

