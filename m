Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaJVS3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:29:40 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42660 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbaJVS3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:29:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/2] mm: memcontrol: fix race between migration and writeback
Date: Wed, 22 Oct 2014 14:29:26 -0400
Message-Id: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is fall-out from the memcg lifetime rework in 3.17, where
writeback statistics can get lost against a migrating page.

The (-stable) fix is adapting the page stat side to the new lifetime
rules, rather than making an exception specifically for them, which
seems less error prone and generally the right way forward.

 include/linux/memcontrol.h | 58 ++++++++++++++--------------------------------
 include/linux/mm.h         |  1 -
 mm/memcontrol.c            | 54 ++++++++++++++++++------------------------
 mm/page-writeback.c        | 43 ++++++++++++----------------------
 mm/rmap.c                  | 20 ++++++++--------
 5 files changed, 64 insertions(+), 112 deletions(-)

