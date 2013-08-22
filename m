Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab3HVSjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:39:24 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:44695 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3HVSjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:39:23 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>, security@kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] Rename nsproxy.pid_ns and fix a related security bug
Date: Thu, 22 Aug 2013 11:39:14 -0700
Message-Id: <cover.1377196394.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In:

    commit 92f28d973cce45ef5823209aab3138eb45d8b349
    Author: Eric W. Biederman <ebiederm@xmission.com>
    Date:   Fri Mar 15 01:03:33 2013 -0700

        scm: Require CAP_SYS_ADMIN over the current pidns to spoof pids.

Eric fell for my bogus claim that nsproxy->pid_ns was the current'
process's pid ns.  This isn't true.

Let's fix the bug and rename pid_ns so that no one gets this wrong again.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Andy Lutomirski (2):
  net: Check the correct namespace when spoofing pid over SCM_RIGHTS
  Rename nsproxy.pid_ns to nsproxy.pid_ns_for_children

 include/linux/nsproxy.h |  6 +++++-
 kernel/fork.c           |  5 +++--
 kernel/nsproxy.c        | 27 ++++++++++++++-------------
 kernel/pid_namespace.c  |  4 ++--
 net/core/scm.c          |  2 +-
 5 files changed, 25 insertions(+), 19 deletions(-)

-- 
1.8.3.1

