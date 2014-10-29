Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaJ2TZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:25:03 -0400
Received: from mx02.posteo.de ([89.146.194.165]:51392 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbaJ2TZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:25:01 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, akpm@linux-foundation.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 0/3] char: misc: assign file->private_data to miscdevice on open
Date: Wed, 29 Oct 2014 20:22:55 +0100
Message-Id: <1414610578-22779-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This slightly changes the behaviour of miscdevice drivers at an open()
syscall. Not only if the driver happens to implement an open() fop itself,
but now just always file->private_data points to struct miscdevice, when
a user opens the device file.

This call for review once more: if anybody has an hour to kill:

Look for the only dangerous situation where a miscdevice driver _depends_ on
file->private_data being NULL when _not_ implementing an open() routine
itself. I didn't find anything.

The one section I was unsure about should be ok, see
http://marc.info/?l=linux-kernel&m=141376535132316&w=2

Bonus: one could look for drivers that _do_ implement open()
and do the (in any case) redundant work themselves.

Martin Kepplinger (3):
  misc: always assign miscdevice to file->private_data in open()
  fbdev: pxa3xx-gcu: remove redundant implementation of open()
  char: misc: document behaviour of open()

 drivers/char/misc.c              |    6 ++++--
 drivers/video/fbdev/pxa3xx-gcu.c |   10 ----------
 2 files changed, 4 insertions(+), 12 deletions(-)

-- 
1.7.10.4

