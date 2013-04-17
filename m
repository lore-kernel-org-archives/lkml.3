Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3DQJ4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:56:11 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:33579 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753260Ab3DQJ4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:56:09 -0400
In-Reply-To: <516D90F6.3020603@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.4 March 27, 2005
Message-ID: <OF79A40956.94F46B9C-ON48257B50.00320F73-48257B50.0036925D@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Wed, 17 Apr 2013 17:55:29 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-04-17 17:55:21,
	Serialize complete at 2013-04-17 17:55:21
Content-Type: text/plain; charset="US-ASCII"
X-MAIL: mse02.zte.com.cn r3H9taGC072230
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart <dvhart@linux.intel.com> wrote on 2013/04/17 01:57:10:

> Again, a functional testcase in futextest would be a good idea. This
> helps validate the patch and also can be used to identify regressions in
> the future.

I will post the testcase code later.

> 
> What is the max value of comp_idx? Are we at risk of truncating it?
> Looks like not really from my initial look.
> 
> This also needs a comment in futex.h describing the usage of the offset
> field in union futex_key as well as above get_futex_key describing the
> key for shared mappings.
> 
> 

As far as I know , the max size of one hugepage is 1 GBytes for x86 cpu.
Can some other cpus support greater hugepage even more than 4 GBytes? If 
so, we can change the type of 'offset' from int to long to avoid 
truncating.
