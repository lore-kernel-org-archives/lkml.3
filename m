Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751060Ab3FXVCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:02:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:42552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3FXVCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:02:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,930,1363158000"; 
   d="scan'208";a="321911845"
Message-ID: <1372107737.7914.27.camel@envy.home>
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
From: Darren Hart <dvhart@linux.intel.com>
To: zhang.yi20@zte.com.cn
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, Zhang Yi <wetpzy@gmail.com>
Date: Mon, 24 Jun 2013 14:02:17 -0700
In-Reply-To: <OF7A810108.AA9BB6C1-ON48257B6D.000A1424-48257B6D.000B1EC6@zte.com.cn>
References: <000101ce5174$1962bac0$4c283040$@com>
	 <20130515142035.GD11497@suse.de>
	 <OF1450163D.E6FBE6A2-ON48257B6D.00048ADD-48257B6D.00070A58@zte.com.cn>
	 <519436B7.2050101@linux.intel.com>
	 <OF7A810108.AA9BB6C1-ON48257B6D.000A1424-48257B6D.000B1EC6@zte.com.cn>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 10:00 +0800, zhang.yi20@zte.com.cn wrote:
> 
> Darren Hart <dvhart@linux.intel.com> wrote on 2013/05/16 09:30:31:
> 
> >
> > pgoff_t is an unsigned long, and page_to_pfn() returns an unsigned long.
> > Since compound_idx can be assigned from page_to_pfn() and it is added
> > with index in the return value, unsigned long seems like a better choice
> > to me. Is there a specific reason you prefer an int? It might be "fine"
> > but it is likely to raise eyebrows whenever someone read through it.
> >
> No other specific  reason. I just think that int is enough.

Hi Yi,

I believe this patch is still pending a final version from you. Mel and
I both asked after the change of compound_idx from int to unsigned long.
While "int" may be adequate, for consistency with the return type
assigned and such, the unsigned long is preferred. Could you respin and
send along the patch so Thomas can pull it in?

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

