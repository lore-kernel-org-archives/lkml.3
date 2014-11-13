Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934484AbaKMWJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:09:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934044AbaKMWJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:09:38 -0500
Date: Thu, 13 Nov 2014 14:09:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: linux@rasmusvillemoes.dk, gong.chen@linux.intel.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        " Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel@stlinux.com, eric.paire@st.com
Subject: Re: [PATCH v4] bitops: Fix shift overflow in GENMASK macros
Message-Id: <20141113140936.e2e45a8970b5bb4195fd5065@linux-foundation.org>
In-Reply-To: <1415267659-10563-1-git-send-email-maxime.coquelin@st.com>
References: <1415267659-10563-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Nov 2014 10:54:19 +0100 Maxime COQUELIN <maxime.coquelin@st.com> wrote:

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
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Why cc:stable?  Does this bug cause some observed kernel misbehaviour? 
If so, please fully describe that in the changelog.  This will help
people to determine whether this patch might fix a bug they're
observing, and will help them to decide whether they should backport
this patch into their kernels.

I'm assuming that Peter will be merging this patch.

