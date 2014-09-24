Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaIXKAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:00:12 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:7502 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491AbaIXKAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:00:09 -0400
X-IronPort-AV: E=Sophos;i="5.04,588,1406563200"; 
   d="scan'208";a="36394362"
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segooon@gmail.com>, Mateusz Guzik <mguzik@redhat.com>
Subject: [PATCHv3 0/2] ns, procfs: pid conversion between ns and showing pidns hierarchy
Date: Wed, 24 Sep 2014 18:00:25 +0800
Message-ID: <1411552827-31056-1-git-send-email-chenhanxiao@cn.fujitsu.com>
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

v3: fix a race issue and memory leak issue
    in pidns_hierarchy.
v2: use a procfs text file instead of dirs
    to show the hierarchy of pid namespace

Chen Hanxiao (2):
  procfs: show hierarchy of pid namespace
  /proc/PID/status: show all sets of pid according to ns

 fs/proc/Kconfig           |   6 ++
 fs/proc/Makefile          |   1 +
 fs/proc/array.c           |  17 ++++
 fs/proc/pidns_hierarchy.c | 227 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 251 insertions(+)
 create mode 100644 fs/proc/pidns_hierarchy.c

-- 
1.9.0

