Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbaGNWjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:39:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:46489 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbaGNWjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:39:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,661,1400050800"; 
   d="scan'208";a="456922858"
Date: Mon, 14 Jul 2014 15:39:18 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf, x86: Don't mark DataLA addresses as store
Message-ID: <20140714223918.GE5803@tassilo.jf.intel.com>
References: <1405123285-23544-1-git-send-email-andi@firstfloor.org>
 <1405123285-23544-2-git-send-email-andi@firstfloor.org>
 <CABPqkBScNfoK4a9BZkZxB-gAj3Ew2f7Ox3351YKWVt7cN-1EEw@mail.gmail.com>
 <20140714192451.GC5803@tassilo.jf.intel.com>
 <CABPqkBS=PB9tp78Y12ZRG9KLjd=DLY=3yrXeRdqCbZ4gnsdJ7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS=PB9tp78Y12ZRG9KLjd=DLY=3yrXeRdqCbZ4gnsdJ7A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a problem with this patch.
> 
> It makes: perf mem -t store rec record OP_NA for the store.
> It was recording OP_STORE before.
> 
> I think we need to keep LD/ST info. This is useful for analysis
> especially if we collect loads/stores simultaneously.
> 
> Was working before for the mem-loads, mem-stores events.

Ok. Would it be enough if it only worked for "mem-stores" and not 
all PEBS events? 

Otherwise have to go back to an even larger PEBS constraint 
table for HSW than before.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
