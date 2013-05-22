Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab3EVJau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:30:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:15450 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3EVJas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:30:48 -0400
X-Spam-Score: -100.8
Message-ID: <519C900F.1040008@asianux.com>
Date: Wed, 22 May 2013 17:29:51 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] kernel/sched/core.c: need return NULL when BUG() is defined
 as empty.
References: <5199D565.4070307@asianux.com> <20130522091156.GC18810@twins.programming.kicks-ass.net>
In-Reply-To: <20130522091156.GC18810@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 05:11 PM, Peter Zijlstra wrote:
> On Mon, May 20, 2013 at 03:48:53PM +0800, Chen Gang wrote:
>> > 
>> > When neither CONFIG_BUG nor HAVE_ARCH_BUG is defined, need let function
>> > return failure value ('NULL') instead of random value.
> What will such a kernel do? Happily continue running whenever we hit a
> BUG? that seems like a particularly bad idea. Should we not have a stub
> BUG() function like:
> 
> void BUG(void) __attribute__((noreturn))
> {
> 	local_irq_disable();
> 	while (1) ;
> }
> 
> Which would at least halt things?
> 
> 

At least for me, it is a good idea. :-)

In menuconfig we can set !CONFIG_BUG and !HAVE_ARCH_BUG manually under
any architectures:

  "> General setup > Configure standard kernel features (expert users) > BUG() Support"

So I think, we really need your patch.


Thanks.
-- 
Chen Gang

Asianux Corporation
