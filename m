Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaKDN1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:27:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:37107 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaKDN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:27:39 -0500
Date: Tue, 4 Nov 2014 14:27:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: gong.chen@linux.intel.com, Ingo Molnar <mingo@kernel.org>,
        " Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel@stlinux.com, eric.paire@st.com
Subject: Re: [PATCH v3] bitops: Fix shift overflow in GENMASK macros
Message-ID: <20141104132731.GO3337@twins.programming.kicks-ass.net>
References: <1415098697-16304-1-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415098697-16304-1-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:58:17AM +0100, Maxime COQUELIN wrote:
> On some 32 bits architectures, including x86, GENMASK(31, 0) returns 0
> instead of the expected ~0UL.
> 
> This is the same on some 64 bits architectures with GENMASK_ULL(63, 0).
> 
> This is due to an overflow in the shift operand, 1 << 32 for GENMASK,
> 1 << 64 for GENMASK_ULL.
> 
> Fixes: 10ef6b0dffe404bcc54e94cb2ca1a5b18445a66b
> Cc: <stable@vger.kernel.org> #v3.13+
> Reported-by: Eric Paire <eric.paire@st.com>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>


There doesn't appear to be a clear maintainer for this file, so I'll try
and stick in in tip.

Thanks!

