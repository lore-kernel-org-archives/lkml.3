Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaJCExY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 00:53:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaJCExX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 00:53:23 -0400
Message-ID: <1412311972.27162.3.camel@linux-t7sj.site>
Subject: Re: [RFC PATCH] Perf Bench: Locking Microbenchmark
From: Davidlohr Bueso <dbueso@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Tuan Bui <tuan.d.bui@hp.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@kernel.org,
        artagnon@gmail.com, jolsa@redhat.com, dvhart@linux.intel.com,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org
Date: Thu, 02 Oct 2014 21:52:52 -0700
In-Reply-To: <20141001052832.GA32248@gmail.com>
References: <1412120999.2941.11.camel@u64>
	 <20141001052832.GA32248@gmail.com>
Organization: SUSE Labs
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 07:28 +0200, Ingo Molnar wrote:
> If you compare an strace of AIM7 steady state and 'perf bench 
> lock' steady state, is it comparable, i.e. do the syscalls and 
> other behavioral patterns match up?

With more than 1000 users I'm seeing:

-  33.74%    locking-creat  [kernel.kallsyms]              [k] mspin_lock                                                                                                ◆
   + mspin_lock                                                                                                                                                          ▒
   + __mutex_lock_slowpath                                                                                                                                               ▒
   + mutex_lock                                                                                                                                                          ▒
-   7.97%    locking-creat  [kernel.kallsyms]              [k] mutex_spin_on_owner                                                                                       ▒
   + mutex_spin_on_owner                                                                                                                                                 ▒
   + __mutex_lock_slowpath                                                                                                                                               ▒
   + mutex_lock                                                                                                     

Lower users count just shows the syscall entries.

Of course, the aim7 setup was running on a ramdisk, thus avoiding any IO
overhead in the traces.

Thanks,
Davidlohr

