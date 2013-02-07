Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab3BGQlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:41:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28899 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758867Ab3BGQlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:41:22 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=M5gr15I6uLgA:10 a=PNZvL5FgI8DhFM0sXFAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360255280.2621.70.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
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
Date: Thu, 07 Feb 2013 11:41:20 -0500
In-Reply-To: <CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	 <1360205415.2621.60.camel@gandalf.local.home>
	 <20130207111025.GD8945@gmail.com>
	 <CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-07 at 17:25 +0100, Frederic Weisbecker wrote:

> At least for now we seem to agree on CONFIG_NO_HZ_IDLE and keep
> CONFIG_NO_HZ for compatibility. Are you ok with that? If so I'll send
> a patch.

I believe that Ingo was suggesting to have CONFIG_NO_HZ give options to
what type of config NO_HZ you want. Something like:

config NO_HZ
	bool "Enable tickless support"

config NO_HZ_IDLE
	bool "Stop tick when CPU is idle"
	default y
	depends on NO_HZ

config NO_HZ_TASK
	bool "Stop tick on specified CPUs when single task is running"
	default n
	depends on NO_HZ

That is, if you select NO_HZ, by default NO_HZ_IDLE is also selected.
But in the kernel the NO_HZ_IDLE is used.

-- Steve


