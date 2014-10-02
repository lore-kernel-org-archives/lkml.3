Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaJBVjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:39:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaJBVjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:39:19 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Subject: [PATCH 0/7] audit fsnotify cleanups for watches and trees
Date: Thu,  2 Oct 2014 17:38:42 -0400
Message-Id: <cover.1412285491.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a collection of patches to clean up some issues discovered while
implementing audit by exe path.

They compile and have been lightly tested.

I'd be interested in feedback about approaches or details or grossly
misunderstanding some fundamental concepts.

Thanks!

Richard Guy Briggs (7):
  audit: put rule existence check in canonical order
  audit: cull redundancy in audit_rule_change
  audit: eliminate string copy for new tree rules
  audit: optimize add to parent skipping needless search and consuming
    parent ref
  audit: remove redundant watch refcount
  audit: remove extra audit_get_parent()
  audit: rename audit_log_remove_rule to disambiguate for trees

 kernel/audit_tree.c  |   13 +++++++------
 kernel/audit_watch.c |   29 ++++++++++++++++-------------
 kernel/auditfilter.c |   34 +++++++++++-----------------------
 3 files changed, 34 insertions(+), 42 deletions(-)

