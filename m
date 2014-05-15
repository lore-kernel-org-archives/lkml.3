Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaEOCe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 22:34:59 -0400
Received: from one.firstfloor.org ([193.170.194.197]:33791 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaEOCe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 22:34:58 -0400
Date: Thu, 15 May 2014 04:34:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Joe Mario <jmario@redhat.com>
Subject: Re: Haswell mem-store question
Message-ID: <20140515023455.GB1873@two.firstfloor.org>
References: <20140514205021.GU39568@redhat.com>
 <CABPqkBQay_-KHkyFjMP5eq+8RYz1Uy7ske61qbpX5hPvvthw2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQay_-KHkyFjMP5eq+8RYz1Uy7ske61qbpX5hPvvthw2g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it should do:
> 
> if (status & 1)
>         dse.mem_lvl = PERF_MEM_LVL_L1|PERF_MEM_LVL_HIT;
> else
>         dse.mem_lvl = PERF_MEM_LVL_L1|PERF_MEM_LVL_MISS;
> 
> Otherwise you have L1 as the level with no hit/miss info.

Agreed.

BTW the line before is also not always corect, and any event not
explicitely store can only fill in NA


-Andi
