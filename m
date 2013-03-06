Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab3CFKSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:18:24 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64517 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3CFKSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:18:22 -0500
Date: Wed, 6 Mar 2013 11:18:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Illyas Mansoor <illyas.mansoor@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, X86 <x86@kernel.org>,
        Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Rudramuni, Vishwesh M" <vishwesh.m.rudramuni@intel.com>,
        richard@nod.at, josh@joshtriplett.org,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        "Sil, Dyut K" <dyut.k.sil@intel.com>
Subject: Re: [PATCH] x86: fix idle notifier not being called in CONFIG_X86_32
Message-ID: <20130306101818.GA6587@gmail.com>
References: <1362375673-29287-1-git-send-email-illyas.mansoor@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362375673-29287-1-git-send-email-illyas.mansoor@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Illyas Mansoor <illyas.mansoor@intel.com> wrote:

> Idle notifier not registered if CONFIG_X86_32 is defined,
> those callbacks are empty for X86_32 platform.
> 
> ifdef CONFIG_X86_64
>  void enter_idle(void);
>  void exit_idle(void);
> else
> static inline void enter_idle(void) { }
> static inline void exit_idle(void) { }
> static inline void __exit_idle(void) { }
> endif
> 
> Make this work on X86_32 platforms by
> removing the restriction for X86_64

What will they be used for?

Thanks,

	Ingo
