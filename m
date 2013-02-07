Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab3BGLKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:10:33 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:35843 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab3BGLKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:10:32 -0500
Date: Thu, 7 Feb 2013 12:10:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
Message-ID: <20130207111025.GD8945@gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
 <1360205415.2621.60.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360205415.2621.60.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> I'll reply to this as I come up with comments.
> 
> First thing is, don't call it NO_HZ_FULL. A better name would 
> be NO_HZ_CPU. I would like to reserve NO_HZ_FULL when we 
> totally remove jiffies :-)

I don't think we want yet another config option named in a 
weird way.

What we want instead is to just split NO_HZ up into its 
conceptual parts:

   CONFIG_NO_HZ_IDLE
   CONFIG_NO_HZ_USER_SPACE
   CONFIG_NO_HZ_KERNEL_SPACE

Where the current status quo is NO_HZ_IDLE=y, and Frederic is 
about to introduce NO_HZ_USER_SPACE=y. When jiffies get removed 
we get NO_HZ_KERNEL_SPACE=y.

The 'CONFIG_NO_HZ' meta-option, which we should leave for easy 
configurability and for compatibility, should get us the 
currently recommended default, which for the time being might 
be:

   CONFIG_NO_HZ_IDLE=y
   # CONFIG_NO_HZ_USER_SPACE is disabled

Btw., you could add CONFIG_NO_HZ_KERNEL_SPACE right away, just 
keep it false all the time. That would document our future plans 
pretty well.

Once CONFIG_NO_HZ_USER_SPACE is proven problem-free, we might 
default to:

   CONFIG_NO_HZ_IDLE=y
   CONFIG_NO_HZ_USER_SPACE=y

The goal is to have this in the distant future:

   CONFIG_NO_HZ=y

   CONFIG_NO_HZ_IDLE=y
   CONFIG_NO_HZ_USER_SPACE=y
   CONFIG_NO_HZ_KERNEL_SPACE=y

And eventually we might even be able to get rid of all the 3 
variants, and only offer full-on/off.

Agreed?

Thanks,

	Ingo
