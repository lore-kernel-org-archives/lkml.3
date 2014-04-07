Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaDGI0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:26:53 -0400
Received: from relay.parallels.com ([195.214.232.42]:34032 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaDGI0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:26:49 -0400
Message-ID: <5342613E.2090900@parallels.com>
Date: Mon, 7 Apr 2014 12:26:38 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <devel@openvz.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH -mm 2/3] lockdep: mark rwsem_acquire_read as recursive
References: <cover.1396779337.git.vdavydov@parallels.com> <8c6473e959a4557d8622a6d7ff24888cb3f7512d.1396779337.git.vdavydov@parallels.com> <20140407081336.GC11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140407081336.GC11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 12:13 PM, Peter Zijlstra wrote:
> On Sun, Apr 06, 2014 at 07:33:51PM +0400, Vladimir Davydov wrote:
>> rw_semaphore implementation allows recursing calls to down_read, but
>> lockdep thinks that it doesn't. As a result, it will complain
>> false-positively, e.g. if we do not observe some predefined locking
>> order when taking an rw semaphore for reading and a mutex.
>>
>> This patch makes lockdep think rw semaphore is read-recursive, just like
>> rw spin lock.
> Uhm no rwsem isn't read recursive.

Yeah, I was mistaken and is already reworking my set. Please sorry for
the noise.

Thanks.
