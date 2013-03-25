Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab3CYRSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:18:24 -0400
Received: from mail-gh0-f178.google.com ([209.85.160.178]:32981 "EHLO
	mail-gh0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3CYRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:18:22 -0400
Message-ID: <51507FFA.4020403@kernel.org>
Date: Mon, 25 Mar 2013 12:48:58 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Mansoor, Illyas" <illyas.mansoor@intel.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, X86 <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Rudramuni, Vishwesh M" <vishwesh.m.rudramuni@intel.com>,
        "richard@nod.at" <richard@nod.at>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        "Sil, Dyut K" <dyut.k.sil@intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86: fix idle notifier not being called in CONFIG_X86_32
References: <1362375673-29287-1-git-send-email-illyas.mansoor@intel.com> <20130306101818.GA6587@gmail.com> <810586B7581CC8469141DADEBC37191224F77316@BGSMSX102.gar.corp.intel.com> <20130306103627.GC16827@gmail.com> <810586B7581CC8469141DADEBC37191224F773F0@BGSMSX102.gar.corp.intel.com>
In-Reply-To: <810586B7581CC8469141DADEBC37191224F773F0@BGSMSX102.gar.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm okay with this patch since it makes 32-bit and 64-bit consistent,
and technically, it fixes a regression.

If/when we get rid of the notifier, we should do it for both 32-and
64-bit at the same time.

It isn't clear to me that Alex's work will solve this particular
problem, or that there is a code or logical conflict -- though
maybe you are referring to some code I've not read yet.

So for this trivial patch...
Acked-by: Len Brown <len.brown@intel.com>

But I think the bigger problem here is the expectation that out of tree
drivers will not break.  The interactive governor is not upstream.

Len Brown, Intel Open Source Technology Center

