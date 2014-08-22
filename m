Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbaHVSMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:12:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:25553 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbaHVSMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:12:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,382,1406617200"; 
   d="scan'208";a="592013010"
Subject: Re: [PATCH] [v3] warn on performance-impacting configs aka.
 TAINT_PERFORMANCE
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        peterz@infradead.org, mingo@redhat.com, ak@linux.intel.com,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, lauraa@codeaurora.org
In-Reply-To: <53F773A2.7040904@sr71.net>
References: <20140821202424.7ED66A50@viggo.jf.intel.com>
	 <1408725157.4347.14.camel@schen9-DESK>  <53F773A2.7040904@sr71.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Aug 2014 11:12:40 -0700
Message-ID: <1408731160.4347.26.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 09:45 -0700, Dave Hansen wrote:
> On 08/22/2014 09:32 AM, Tim Chen wrote:
> >> > +#ifdef CONFIG_DEBUG_OBJECTS_FREE
> >> > +	"DEBUG_OBJECTS_FREE",
> >> > +#endif
> >> > +#ifdef CONFIG_DEBUG_KMEMLEAK
> >> > +	"DEBUG_KMEMLEAK",
> >> > +#endif
> >> > +#ifdef CONFIG_DEBUG_PAGEALLOC
> >> > +	"DEBUG_PAGEALLOC",
> > I think coverage profiling also impact performance.
> > So I sould also put CONFIG_GCOV_KERNEL in the list.
> 
> Would CONFIG_GCOV_PROFILE_ALL be the better one to check?  With plain
> GCOV_KERNEL, I don't think we will, by default, put the coverage
> information in any files and slow them down.

CONFIG_GCOV_PROFILE_ALL is definitely a no no regarding to
performance impact, which is mentioned in the gcov documentation.

I haven't tested this, but if profiling is turned on only for
a piece of code that is performance critical but not for
the whole kernel, in theory performance can still be impacted
with the overhead.  So I think it is safer to check
for CONFIG_GCOV_KERNEL, that has no reason to be turned on
for any workload that's performance critical.

Tim


