Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab3DZIzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:55:15 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:43462 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706Ab3DZIzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:55:12 -0400
Message-ID: <517A3F40.1030707@gmail.com>
Date: Fri, 26 Apr 2013 10:48:00 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 0/4] fsfreeze: from uninterruptible to killable
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I re-send the patch series. The first three patches are not changed 
since the last review, but I add a fourth patch to manage the killable 
state in mnt_want_write/mnt_want_write_file. I did some tests and it 
seems ok to me. The hot points were do_last, kern_path_create and 
mq_open. At the moment the path not covered is the page_mkwrite, however 
it could be covered with a future patch. The work made until now is 
sufficient to give the user the possibility to do a "kill -9" in several 
cases.

Marco Stornelli (4):
   fsfreeze: wait in killable state in __sb_start_write
   fsfreeze: added new file_start_write_killable
   fsfreeze: use sb_start_write_killable instead of sb_start_write
   fsfreeze: return EINTR from mnt_want_write and mnt_want_write_file

  drivers/block/loop.c |    4 +++-
  fs/aio.c             |    7 +++++--
  fs/coda/file.c       |    4 +++-
  fs/namei.c           |    6 ++++++
  fs/namespace.c       |    8 ++++++--
  fs/open.c            |    8 ++++++--
  fs/read_write.c      |   28 +++++++++++++++++-----------
  fs/splice.c          |    4 +++-
  fs/super.c           |   24 ++++++++++++++++++------
  include/linux/fs.h   |   36 ++++++++++++++++++++++++++++++------
  ipc/mqueue.c         |    6 +++++-
  11 files changed, 102 insertions(+), 33 deletions(-)

-- 
1.7.3.4
---

