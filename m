Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab3GAPUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:20:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:48041 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab3GAPUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:20:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,974,1363158000"; 
   d="scan'208";a="338733369"
From: Andi Kleen <andi@firstfloor.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/7] v2 Provide infrastructure for full-system idle
References: <20130628200949.GA17458@linux.vnet.ibm.com>
Date: Mon, 01 Jul 2013 08:19:25 -0700
In-Reply-To: <20130628200949.GA17458@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Fri, 28 Jun 2013 13:09:50 -0700")
Message-ID: <87a9m65mv6.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>
> The individual patches are as follows:
>
> 1.	Add a CONFIG_NO_HZ_FULL_SYSIDLE Kconfig parameter to enable
> 	this feature.  Kernels built with CONFIG_NO_HZ_FULL_SYSIDLE=n
> 	act exactly as they do today.

Is this extra CONFIG option really needed? RCU already has a bewildering
variety of CONFIG options, and no idle CONFIG is also pretty complicated. 
At some point noone will know how to configure kernels anymore if 
these non trivial, complicated trade off CONFIGs keep spreading.

The facility sounds like a good thing in general. Just enable
it implicitely with NO_HZ_SYSIDLE ? 

If you want a switch for testing I would advise a sysctl or sysfs knob

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
