Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161332Ab3DEKgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:36:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161159Ab3DEKgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:36:54 -0400
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 05 Apr 2013 11:34:45 +0100
Message-ID: <1365158085.2735.25.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes,

Steve.

----------------------------------------------------------------------------

There are two patches which fix up a couple of minor issues in the DLM
interface code, a missing error path in gfs2_rs_alloc(), two patches
which fix problems during "withdraw" and a fix for discards/FITRIM when
using 4k sector sized devices.

----------------------------------------------------------------------------
The following changes since commit 66ade474237745a57b7e87da9a93c7ec69fd52bb:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2013-04-03 16:15:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git master

Akinobu Mita (1):
      GFS2: use memchr_inv

Bob Peterson (1):
      GFS2: Issue discards in 512b sectors

David Teigland (2):
      GFS2: use kmalloc for lvb bitmap
      GFS2: Fix unlock of fcntl locks during withdrawn state

Steven Whitehouse (1):
      GFS2: Fix unlock of fcntl locks during withdrawn state

Wei Yongjun (1):
      GFS2: return error if malloc failed in gfs2_rs_alloc()

 fs/dlm/plock.c     |   18 +++++++++++++++---
 fs/gfs2/file.c     |    5 ++++-
 fs/gfs2/incore.h   |    1 +
 fs/gfs2/lock_dlm.c |   39 ++++++++++++++++++++-------------------
 fs/gfs2/rgrp.c     |   32 ++++++++++++++------------------
 5 files changed, 54 insertions(+), 41 deletions(-)


