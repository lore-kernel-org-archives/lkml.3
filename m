Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaBWRGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 12:06:44 -0500
Received: from sh.osrg.net ([192.16.179.4]:42805 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbaBWRGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 12:06:42 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 0/3] nilfs2 additional updates
Date: Mon, 24 Feb 2014 01:58:38 +0900
Message-Id: <1393174721-27246-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.3
X-Dispatcher: imput version 20100215(IM150)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Mon, 24 Feb 2014 02:06:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please queue this patchset for the next merge window.

Andreas's two patches will add FITRIM ioctl support to nilfs.  The
original cover letter can be seen at:

 [1] http://marc.info/?l=linux-nilfs&m=139314496625648
     "[PATCH v4 0/2] nilfs2: add support for FITRIM ioctl"

My patch adds missing range checks of metadata sizes read from disk,
and prevents potential memory access violations due to invalid sizes.
This is for the issue pointed out in the following comment.

 [2] http://marc.info/?l=linux-nilfs&m=139153213412866
     "Re: [PATCH 3/4] nilfs2: add nilfs_sufile_set_suinfo to update
     segment usage"

Thanks in advance,
Ryusuke Konishi
--
Andreas Rohner (2):
      nilfs2: add nilfs_sufile_trim_fs to trim clean segs
      nilfs2: add FITRIM ioctl support for nilfs2

Ryusuke Konishi (1):
      nilfs2: verify metadata sizes read from disk

 fs/nilfs2/cpfile.c        |   12 ++++
 fs/nilfs2/dat.c           |   12 ++++
 fs/nilfs2/ioctl.c         |   45 +++++++++++++
 fs/nilfs2/sufile.c        |  164 +++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/sufile.h        |    1 +
 fs/nilfs2/the_nilfs.c     |   10 +++
 include/linux/nilfs2_fs.h |    8 +++
 7 files changed, 252 insertions(+)

