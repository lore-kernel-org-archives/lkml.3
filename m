Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3DMKlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 06:41:53 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:59557 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab3DMKlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 06:41:51 -0400
Message-ID: <516934C0.2080103@gmail.com>
Date: Sat, 13 Apr 2013 12:34:40 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 0/3 v3][RFC] fsfreeze: from uninterruptible to killable
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I rebased the work on top of -next and I applied a Jan's comment about __sb_start_write.
I did some basic tests and they are ok.

Open points:
- without change mnt_want_write several paths are still blocking paths;
- page_mkwrite still call blocking variant of __sb_start_write.

Any comments are welcome.

Regards.

Marco Stornelli (3):
  fsfreeze: wait in killable state in __sb_start_write
  fsfreeze: added new file_start_write_killable
  fsfreeze: use sb_start_write_killable instead of sb_start_write

 drivers/block/loop.c |    4 +++-
 fs/aio.c             |    7 +++++--
 fs/coda/file.c       |    4 +++-
 fs/open.c            |    8 ++++++--
 fs/read_write.c      |   28 +++++++++++++++++-----------
 fs/splice.c          |    4 +++-
 fs/super.c           |   24 ++++++++++++++++++------
 include/linux/fs.h   |   36 ++++++++++++++++++++++++++++++------
 8 files changed, 85 insertions(+), 30 deletions(-)

-- 
1.7.3.4
---

