Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbaE2BtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 21:49:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbaE2BtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 21:49:19 -0400
Message-ID: <538691FB.8060309@redhat.com>
Date: Wed, 28 May 2014 21:48:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
CC: Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Mike Marciniszyn <infinipath@intel.com>
Subject: Re: [RFC][PATCH 1/5] mm: Introduce VM_PINNED and interfaces
References: <20140526145605.016140154@infradead.org> <20140526152107.823060865@infradead.org>
In-Reply-To: <20140526152107.823060865@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 10:56 AM, Peter Zijlstra wrote:

>  include/linux/mm.h       |    3 +
>  include/linux/mm_types.h |    5 +
>  kernel/fork.c            |    2 
>  mm/mlock.c               |  133 ++++++++++++++++++++++++++++++++++++++++++-----
>  mm/mmap.c                |   18 ++++--
>  5 files changed, 141 insertions(+), 20 deletions(-)

I'm guessing you will also want a patch that adds some code to
rmap.c, madvise.c, and a few other places to actually enforce
the VM_PINNED semantics?

-- 
All rights reversed
