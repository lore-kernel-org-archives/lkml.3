Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3H0Ol2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab3H0Ol1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:41:27 -0400
From: Jan Kaluza <jkaluza@redhat.com>
To: davem@davemloft.net
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        eparis@redhat.com, rgb@redhat.com, Jan Kaluza <jkaluza@redhat.com>
Subject: [PATCH 0/3] Send audit/procinfo/cgroup data in socket-level control message
Date: Tue, 27 Aug 2013 16:39:57 +0200
Message-Id: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset against net-next (applies also to linux-next) adds 3 new types
of "Socket"-level control message (SCM_AUDIT, SCM_PROCINFO and SCM_CGROUP).
This is needed by journald (logging daemon used as part of systemd ecosystem)
to get additional context together with log messages received using UNIX socket.

Jan Kaluza (3):
  Send loginuid and sessionid in SCM_AUDIT
  Send comm and cmdline in SCM_PROCINFO
  Send cgroup_path in SCM_CGROUP

 include/linux/socket.h |  9 ++++++
 include/net/af_unix.h  | 10 ++++++
 include/net/scm.h      | 67 ++++++++++++++++++++++++++++++++++++++--
 net/core/scm.c         | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/unix/af_unix.c     | 70 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 237 insertions(+), 2 deletions(-)

-- 
1.8.3.1

