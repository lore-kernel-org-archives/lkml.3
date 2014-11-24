Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751062AbaKXXjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 18:39:42 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62778 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaKXXjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:39:41 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 25 Nov 2014 08:42:37 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] mm/debug-pagealloc: make debug-pagealloc boottime
 configurable
Message-ID: <20141124234237.GA7824@js1304-P5Q-DELUXE>
References: <1416816926-7756-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1416816926-7756-4-git-send-email-iamjoonsoo.kim@lge.com>
 <20141124145542.08b97076.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124145542.08b97076.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 02:55:42PM -0800, Andrew Morton wrote:
> On Mon, 24 Nov 2014 17:15:21 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> 
> > Now, we have prepared to avoid using debug-pagealloc in boottime. So
> > introduce new kernel-parameter to disable debug-pagealloc in boottime,
> > and makes related functions to be disabled in this case.
> > 
> > Only non-intuitive part is change of guard page functions. Because
> > guard page is effective only if debug-pagealloc is enabled, turning off
> > according to debug-pagealloc is reasonable thing to do.
> > 
> > ...
> >
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -858,6 +858,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  			causing system reset or hang due to sending
> >  			INIT from AP to BSP.
> >  
> > +	disable_debug_pagealloc
> > +			[KNL] When CONFIG_DEBUG_PAGEALLOC is set, this
> > +			parameter allows user to disable it at boot time.
> > +			With this parameter, we can avoid allocating huge
> > +			chunk of memory for debug pagealloc and then
> > +			the system will work mostly same with the kernel
> > +			built without CONFIG_DEBUG_PAGEALLOC.
> > +
> 
> Weren't we going to make this default to "off", require a boot option
> to turn debug_pagealloc on?

Hello, Andrew.

I'm afraid that changing default to "off" confuses some old users.
They would expect that it is default "on". But, it is just debug
feature, so, it may be no problem. If you prefer to change default, I
will rework this patch. Please let me know your decision.

Thanks.
