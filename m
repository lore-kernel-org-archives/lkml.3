Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaHVQp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:45:26 -0400
Received: from www.sr71.net ([198.145.64.142]:55306 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaHVQpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:45:25 -0400
Message-ID: <53F773A2.7040904@sr71.net>
Date: Fri, 22 Aug 2014 09:45:22 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com,
        peterz@infradead.org, mingo@redhat.com, ak@linux.intel.com,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, lauraa@codeaurora.org
Subject: Re: [PATCH] [v3] warn on performance-impacting configs aka. TAINT_PERFORMANCE
References: <20140821202424.7ED66A50@viggo.jf.intel.com> <1408725157.4347.14.camel@schen9-DESK>
In-Reply-To: <1408725157.4347.14.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 09:32 AM, Tim Chen wrote:
>> > +#ifdef CONFIG_DEBUG_OBJECTS_FREE
>> > +	"DEBUG_OBJECTS_FREE",
>> > +#endif
>> > +#ifdef CONFIG_DEBUG_KMEMLEAK
>> > +	"DEBUG_KMEMLEAK",
>> > +#endif
>> > +#ifdef CONFIG_DEBUG_PAGEALLOC
>> > +	"DEBUG_PAGEALLOC",
> I think coverage profiling also impact performance.
> So I sould also put CONFIG_GCOV_KERNEL in the list.

Would CONFIG_GCOV_PROFILE_ALL be the better one to check?  With plain
GCOV_KERNEL, I don't think we will, by default, put the coverage
information in any files and slow them down.
