Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965317AbaH0Xht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:37:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935743AbaH0Xhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:37:47 -0400
Date: Wed, 27 Aug 2014 16:37:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, msalter@redhat.com,
        dyoung@redhat.com, riel@redhat.com, peterz@infradead.org,
        mgorman@suse.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, Alex Thorlton <athorlton@sgi.com>
Subject: Re: [PATCH 1/2] x86: Optimize resource lookups for ioremap
Message-Id: <20140827163745.774e9b5c591e8f9cf7542a4d@linux-foundation.org>
In-Reply-To: <53FE68E4.4090902@sgi.com>
References: <20140827225927.364537333@asylum.americas.sgi.com>
	<20140827225927.602319674@asylum.americas.sgi.com>
	<20140827160515.c59f1c191fde5f788a7c42f6@linux-foundation.org>
	<53FE6515.6050102@sgi.com>
	<20140827161854.0619a04653b336d3adc755f3@linux-foundation.org>
	<53FE68E4.4090902@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 16:25:24 -0700 Mike Travis <travis@sgi.com> wrote:

> > 
> > <looks at the code>
> > 
> > Doing strcmp("System RAM") is rather a hack.  Is there nothing in
> > resource.flags which can be used?  Or added otherwise?
> 
> I agree except this mimics the page_is_ram function:
> 
>         while ((res.start < res.end) &&
>                 (find_next_iomem_res(&res, "System RAM", true) >= 0)) {

Yeah.  Sigh.

> So it passes the same literal string which then find_next does the
> same strcmp on it:
> 
>                 if (p->flags != res->flags)
>                         continue;
>                 if (name && strcmp(p->name, name))
>                         continue;
> 
> I should add back in the check to insure name is not NULL.

If we're still at 1+ hours then little bodges like this are nowhere
near sufficient and sterner stuff will be needed.

Do we actually need the test?  My googling turns up zero instances of
anyone reporting the "ioremap on RAM pfn" warning.

Where's the rest of the time being spent?
