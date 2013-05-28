Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab3E1Tg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:36:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38463 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3E1Tg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:36:27 -0400
Message-ID: <51A50708.3000203@oracle.com>
Date: Tue, 28 May 2013 15:35:36 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130527 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/9] liblockdep: Support using LD_PRELOAD
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com> <1368674141-10796-8-git-send-email-sasha.levin@oracle.com> <20130522092453.GH18810@twins.programming.kicks-ass.net>
In-Reply-To: <20130522092453.GH18810@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 05:24 AM, Peter Zijlstra wrote:
> Do we still need this with the glibc __pthread_* static initialization?

Sadly we do.

We need to deal with the two things that cause allocation in our code (because
they loop back into our code via malloc()->malloc_init()->pthread_mutex_init() ).

The first one was the glibc trick to avoid the malloc() caused by dlsym(). The
second one is the malloc() we do when we allocate new lock. Static allocation
deals with that one.


Thanks,
Sasha

