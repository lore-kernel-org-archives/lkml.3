Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab3IJWGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:06:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:23728 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab3IJWGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:06:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,880,1371106800"; 
   d="scan'208";a="401440335"
Date: Tue, 10 Sep 2013 15:06:38 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Kostya Serebryany <kcc@google.com>
Subject: Re: Out-of-bounds access in get_wchan (arch/x86/kernel/process_64.c)
Message-ID: <20130910220638.GG11427@tassilo.jf.intel.com>
References: <CACT4Y+Y6r=HV7nFgbu=B=d-4ka3J4yotRjgX1M1xGkNkFn1sOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y6r=HV7nFgbu=B=d-4ka3J4yotRjgX1M1xGkNkFn1sOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Indeed, get_wchan ensures that fp<stack+THREAD_SIZE, but then dereferences fp+8:
> 
> 434                 if (fp < (unsigned long)stack ||
> 435                     fp >= (unsigned long)stack+THREAD_SIZE)
> 436                         return 0;
> 437                 ip = *(u64 *)(fp+8);
> 
> It must check that fp+8<stack+THREAD_SIZE.
> As far as I see, the bug can lead to garbage return values or in the
> worst case to crash.

Thanks for the report.

The change looks good to me. Can you please submit a formal signed off patch
to x86@kernel.org ?

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
