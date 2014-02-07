Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaBGTk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:40:59 -0500
Received: from cobra.newdream.net ([66.33.216.30]:50447 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaBGTk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:40:57 -0500
Date: Fri, 7 Feb 2014 11:40:57 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for -rc2
Message-ID: <alpine.DEB.2.00.1402071041250.26572@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is an RBD fix for a crash due to the immutable bio changes, an error 
path fix, and a locking fix in the recent redirect support.

Thanks!
sage

----------------------------------------------------------------
Ilya Dryomov (4):
      libceph: fix error handling in ceph_osdc_init()
      libceph: factor out logic from ceph_osdc_start_request()
      libceph: take map_sem for read in handle_reply()
      libceph: do not dereference a NULL bio pointer

 net/ceph/messenger.c  |  8 +++--
 net/ceph/osd_client.c | 84 +++++++++++++++++++++++++++++++++------------------
 2 files changed, 60 insertions(+), 32 deletions(-)
