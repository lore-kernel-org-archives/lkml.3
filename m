Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3EHAmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:42:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:14693 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab3EHAl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:41:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,631,1363158000"; 
   d="scan'208";a="333469332"
Subject: Re: [RFC][PATCH 7/7] drain batch list during long operations
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de
In-Reply-To: <20130507212003.7990B2F5@viggo.jf.intel.com>
References: <20130507211954.9815F9D1@viggo.jf.intel.com>
	 <20130507212003.7990B2F5@viggo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 May 2013 17:42:02 -0700
Message-ID: <1367973722.27102.267.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 14:20 -0700, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This was a suggestion from Mel:
> 
> 	http://lkml.kernel.org/r/20120914085634.GM11157@csn.ul.ie
> 
> Any pages we collect on 'batch_for_mapping_removal' will have
> their lock_page() held during the duration of their stay on the
> list.  If some other user is trying to get at them during this
> time, they might end up having to wait for a while, especially if
> we go off and do pageout() on some other page.
> 
> This ensures that we drain the batch if we are about to perform a
> writeout.
> 
> I added some statistics to the __remove_mapping_batch() code to
> track how large the lists are that we pass in to it.  With this
> patch, the average list length drops about 10% (from about 4.1 to
> 3.8).  The workload here was a make -j4 kernel compile on a VM
> with 200MB of RAM.
> 
> I've still got the statistics patch around if anyone is
> interested.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>


I like this new patch series. Logic is cleaner than my previous attempt.

Acked.

Tim

