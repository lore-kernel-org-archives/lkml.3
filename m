Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbbAIPSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:18:43 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbbAIPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:18:42 -0500
Date: Fri, 9 Jan 2015 16:18:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Hunter, Adrian" <adrian.hunter@intel.com>,
        "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>,
        "acme@infradead.org" <acme@infradead.org>
Subject: Re: [PATCH v8 02/14] perf: Add AUX area to ring buffer for raw data
 streams
Message-ID: <20150109151814.GP3337@twins.programming.kicks-ass.net>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1415972627-37514-3-git-send-email-alexander.shishkin@linux.intel.com>
 <A78C989F6D9628469189715575E55B231E676088@IRSMSX104.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A78C989F6D9628469189715575E55B231E676088@IRSMSX104.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 09:33:00AM +0000, Metzger, Markus T wrote:
> > From: Peter Zijlstra <peterz@infradead.org>
> > 
> > This patch introduces "AUX space" in the perf mmap buffer, intended for
> > exporting high bandwidth data streams to userspace, such as instruction
> > flow traces.
> > 
> > AUX space is a ring buffer, defined by aux_{offset,size} fields in the
> > user_page structure, and read/write pointers aux_{head,tail}, which abide
> > by the same rules as data_* counterparts of the main perf buffer.
> > 
> > In order to allocate/mmap AUX, userspace needs to set up aux_offset to
> > such an offset that will be greater than data_offset+data_size and
> > aux_size to be the desired buffer size. Both need to be page aligned.
> > Then, same aux_offset and aux_size should be passed to mmap() call and
> > if everything adds up, you should have an AUX buffer as a result.
> 
> Why would userspace need to fill in aux_offset and aux_size?  Can't the kernel
> do this when userspace mmaps the aux buffer like it does for the respective
> data_* fields?

I suppose we could; I'm trying to remember why I did it like this, I'm
failing to remember much past yesterday atm :/ 

> How would userspace fill in those fields if it mapped the data buffer read-only?

Good point, its not used much atm. But yes. That also reminds me; we
should probably finish this:

  https://lkml.org/lkml/2013/7/8/154
