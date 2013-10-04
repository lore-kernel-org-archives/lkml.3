Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3JDNwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:52:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:9597 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab3JDNwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:52:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1033,1371106800"; 
   d="scan'208";a="414027005"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Thread-Topic: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Thread-Index: AQHOv3vIHe5gOhmSsEGBHPLZHDmcI5nkkbDA
Date: Fri, 4 Oct 2013 13:52:49 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211B0176@FMSMSX107.amr.corp.intel.com>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
In-Reply-To: <1380724087-13927-24-git-send-email-jack@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Convert qib_get_user_pages() to use get_user_pages_unlocked().  This
> shortens the section where we hold mmap_sem for writing and also removes
> the knowledge about get_user_pages() locking from ipath driver. We also fix
> a bug in testing pinned number of pages when changing the code.
> 

This patch and the sibling ipath patch will nominally take the mmap_sem twice where the old routine only took it once.   This is a performance issue.

Is the intent here to deprecate get_user_pages()?

I agree, the old code's lock limit test is broke and needs to be fixed.   I like the elimination of the silly wrapper routine!

Could the lock limit test be pushed into another version of the wrapper so that there is only one set of mmap_sem transactions?

Mike
