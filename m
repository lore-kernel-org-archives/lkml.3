Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbaICK3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:29:39 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20783 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755364AbaICK3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 06:29:38 -0400
X-IronPort-AV: E=Sophos;i="5.04,456,1406563200"; 
   d="scan'208";a="35453952"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>
Subject: [RFC PATCH 0/3] ns,procfs: pid conversion between ns and showing pidns hierarchy
Date: Wed, 3 Sep 2014 18:29:57 +0800
Message-ID: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series will expose pid inside containers
via procfs.
Also show the hierarchy of pid namespcae.
Then we could know how pid looks inside a container
and their ns relationships.

Chen Hanxiao (3):
  procfs: check uniq proc_dir_entry subdir name
  procfs: show hierarchy of pid namespace
  /proc/pid/status: show all sets of pid according to ns

 fs/proc/Kconfig           |   6 ++
 fs/proc/Makefile          |   1 +
 fs/proc/array.c           |  17 +++++
 fs/proc/generic.c         |  15 +++++
 fs/proc/pidns_hierarchy.c | 161 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h   |   3 +
 6 files changed, 203 insertions(+)
 create mode 100644 fs/proc/pidns_hierarchy.c

-- 
1.9.0

