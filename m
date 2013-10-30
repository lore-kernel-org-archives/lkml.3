Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3J3UZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:25:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab3J3UZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:25:01 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <onestero@redhat.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 0/3] audit: Tidy up audit_context and stop bprm recursion
Date: Wed, 30 Oct 2013 16:24:24 -0400
Message-Id: <cover.1383162177.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a clean up of the audit_aux_data and audit_context structures
and the audit_bprm() call that was needlessly recursing, allocating more
resources than necessary.

Eric W. Biederman (1):
  audit: Kill the unused struct audit_aux_data_capset

Richard Guy Briggs (2):
  audit: remove unused envc member of audit_aux_data_execve
  audit: call audit_bprm() only once to add AUDIT_EXECVE information

 fs/exec.c             |    5 +----
 include/linux/audit.h |   13 +++++--------
 kernel/audit.h        |    3 +++
 kernel/auditsc.c      |   49 ++++++++++---------------------------------------
 4 files changed, 19 insertions(+), 51 deletions(-)

