Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbbAEXIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:08:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbbAEXIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:08:40 -0500
Date: Mon, 5 Jan 2015 18:08:30 -0500
From: Rafael Aquini <aquini@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jweiner@redhat.com,
        dave.hansen@linux.intel.com, rientjes@google.com, linux-mm@kvack.org
Subject: Re: [PATCH v2] fs: proc: task_mmu: show page size in
 /proc/<pid>/numa_maps
Message-ID: <20150105230829.GA28105@t510.redhat.com>
References: <734bca19b3a8f4e191ccc9055ad4740744b5b2b6.1420464466.git.aquini@redhat.com>
 <20150105133500.e0ce4b090e6b378c3edc9c56@linux-foundation.org>
 <20150105225504.GC1795@t510.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105225504.GC1795@t510.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 05:55:04PM -0500, Rafael Aquini wrote:
> > > +	seq_printf(m, " kernelpagesize_kB=%lu", vma_kernel_pagesize(vma) >> 10);
> > 
> > This changes the format of the numa_maps file and can potentially break
> > existing parsers.  Please discuss.
> > 
> > I'd complain about the patch's failure to update the documentation,
> > except numa_maps appears to be undocumented.  Sigh.  What the heck is "N0"?
> >
> That's a nice opportunity to attempt to sharp my doc writing skills.
> Sorry for the total failure to identify it earlier.
> I just took it as a TODO note to send a patch to document this interface soon.
>

Or perhaps that's a sign we should move the numa node locality
information to /proc/$pid/smaps and start printing a deprecation warning
for /proc/$pid/numa_maps users preparing them for a future removal?

 
> Happy new year.
> -- Rafael
