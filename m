Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335Ab3HOTeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 15:34:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:50474 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757521Ab3HOTeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 15:34:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,887,1367996400"; 
   d="scan'208";a="381544950"
From: Andi Kleen <andi@firstfloor.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: aarcange@redhat.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        mgorman@suse.de, riel@redhat.com, minchan@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Fix aio performance regression for database caused by THP
References: <1376590389.24607.33.camel@concerto>
Date: Thu, 15 Aug 2013 12:34:05 -0700
In-Reply-To: <1376590389.24607.33.camel@concerto> (Khalid Aziz's message of
	"Thu, 15 Aug 2013 12:13:09 -0600")
Message-ID: <8738qakatu.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz <khalid.aziz@oracle.com> writes:

> I am working with a tool that simulates oracle database I/O workload.
> This tool (orion to be specific -
> <http://docs.oracle.com/cd/E11882_01/server.112/e16638/iodesign.htm#autoId24>)
> allocates hugetlbfs pages using shmget() with SHM_HUGETLB flag. 

Is this tool available for download?

I would rather prefer to address the locking overhead in THP too.

The fundamental problem is that we have to touch all the pages?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
