Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab3LLN7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:59:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:53294 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab3LLN7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:59:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,878,1378882800"; 
   d="scan'208";a="448948793"
Message-ID: <1386856771.6066.77.camel@tursulin-linux.isw.intel.com>
Subject: Re: Potentially unbounded allocations in seq_read?
From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Dec 2013 13:59:31 +0000
In-Reply-To: <20131212134956.GC10323@ZenIV.linux.org.uk>
References: <1386781481.6066.55.camel@tursulin-linux.isw.intel.com>
	 <20131211174909.GW10323@ZenIV.linux.org.uk>
	 <1386784797.6066.63.camel@tursulin-linux.isw.intel.com>
	 <20131211180703.GY10323@ZenIV.linux.org.uk>
	 <1386855640.6066.73.camel@tursulin-linux.isw.intel.com>
	 <20131212134956.GC10323@ZenIV.linux.org.uk>
Organization: Intel Corporation UK Plc
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 13:49 +0000, Al Viro wrote:
> On Thu, Dec 12, 2013 at 01:40:40PM +0000, Tvrtko Ursulin wrote:
> 
> > So this is the story... task_mmu.c:show_map_vma() calls seq_path. There
> > we have a d_path call which returns -ENAMETOOLONG and keeps doing so
> > even though the buffer grows to huge proportions. It is something on
> > tmpfs, don't know what.
> > 
> > But in the meantime, shouldn't seq_path be a bit more considerate on
> > this particular error and not mark the state as "could not fit" forever?
> > Perhaps it would make sense to limit it a bit?
> > 
> > Or even more so, on errors _other_ than -ENAMETOOLONG it will at the
> > moment mark the result as "need more space". That also sounds broken to
> > me.
> 
> a) *what* errors other than -ENAMETOOLONG?

Is this your way of saying there can't be any other errors from d_path?

> b) d_path() not fitting into 2Mb is definitely a bug.  If you really have
> managed to get a dentry tree 1 million levels deep, you have much worse
> problems.
> c) which kernel version it is?

3.10. I can't imagine this is an actual dentry tree somewhere, probably
just a bug of some sort. I'll probably hunt it down completely some time
next week, time permitting.

Regards,

Tvrtko


