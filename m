Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3C1HpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:45:14 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:52140 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab3C1HpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:45:12 -0400
Date: Thu, 28 Mar 2013 08:45:07 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] nohz: New option to force all CPUs in full dynticks
 range
Message-ID: <20130328074507.GC24433@gmail.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
 <1364398359-21990-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364398359-21990-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +config NO_HZ_EXTENDED_ALL
> +       bool "Full dynticks system on all CPUs"
> +       depends on NO_HZ_EXTENDED
> +       help
> +	 Force all CPUs to be full dynticks. The range specified in the
> +	 nohz_extended boot option will then be ignored.
> +
> +	 Note the boot CPU will still be kept outside the range to handle
> +	 the timekeeping duty.

In most cases this will be the first time users doing 'make oldconfig' 
will hear about this feature, so I'd not mention noh_extended in such a 
primary way at all.

Instead I'd suggest to explain, in a few simple sentences, what 'full 
dynticks' _is_. Then maybe mention this near the end of the next:

   ( Alternatively this feature can also be enabled via the 
     nohz_extended=<cpulist> boot option. If this kernel config option is 
     enabled then the nohz_extended boot parameter is ignored. )

Btw., while at it - I think the nohz_extended boot parameter should _not_ 
be ignored. The .config option should simply provide a default, for the 
case that the user does not have any boot option specified.

If the user specifies a boot option - say to work around a rare installer 
hang in a distro install kernel - then we very much _dont_ want to ignore 
it.

So please put some effort into how this feature is going to interface with 
and be represented to actual users and distro kernel maintainers.

Thanks,

	Ingo
