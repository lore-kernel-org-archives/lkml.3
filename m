Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaKDKo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:44:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:35914 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaKDKo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:44:26 -0500
Date: Tue, 4 Nov 2014 11:44:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: gong.chen@linux.intel.com, Ingo Molnar <mingo@kernel.org>,
        " Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel@stlinux.com, eric.paire@st.com
Subject: Re: [PATCH v2] bitops: Fix shift overflow in GENMASK macros
Message-ID: <20141104104414.GL3337@twins.programming.kicks-ass.net>
References: <1415095437-28723-1-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415095437-28723-1-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:03:57AM +0100, Maxime COQUELIN wrote:

> -#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
> -#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
> +#define GENMASK(h, l)     ((~0UL >> (BITS_PER_LONG - (h - l + 1))) << l)
> +#define GENMASK_ULL(h, l) ((~0ULL >> (BITS_PER_LONG_LONG - (h - l + 1))) << l)

OK, so you need to keep the (h) and (l) bits, macro arguments should be
wrapped in seemingly superfluous braces in order to preserve precedence
on expansion.

My bad for not explicitly doing that when suggesting the alternative.
