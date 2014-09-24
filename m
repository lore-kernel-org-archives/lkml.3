Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaIXPJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:09:21 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:48543 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbaIXPJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:09:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Thelen <gthelen@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>, Dave Hansen <dave@sr71.net>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] mm: memcontrol: performance fixlets for 3.18
Date: Wed, 24 Sep 2014 11:08:55 -0400
Message-Id: <1411571338-8178-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

here are 2 memcg performance fixlets for 3.18.  One improves uncharge
batching to reduce expensive res_counter ops and irq-toggling, the
other one allows THP charges to succeed under cache pressure.

Thanks!

 include/linux/swap.h |   6 ++-
 mm/memcontrol.c      | 116 +++++++++++++------------------------------------
 mm/swap.c            |  27 +++++++++---
 mm/swap_state.c      |  14 ++----
 mm/vmscan.c          |   7 +--
 5 files changed, 63 insertions(+), 107 deletions(-)

