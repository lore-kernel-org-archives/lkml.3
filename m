Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbaFBVlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:41:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:59062 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaFBVgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:36:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,959,1392192000"; 
   d="scan'208";a="548709641"
Subject: [PATCH 00/10] mm: pagewalk: huge page cleanups and VMA passing
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kirill.shutemov@linux.intel.com,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 02 Jun 2014 14:36:44 -0700
Message-Id: <20140602213644.925A26D0@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hugetlbfs and THP support in the walk_page_range() code was
mostly an afterthought.

We also _tried_ to have the pagewalk code be concerned only with
page tables and *NOT* VMAs.  We lost that battle since 80% of
the page walkers just pass the VMA along anyway.

This does a few cleanups and adds a new flavor of walker which
can be stupid^Wsimple and not have to be explicitly taught about
THP.
