Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbaKEQpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:45:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:46646 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbaKEQpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:45:04 -0500
Date: Wed, 5 Nov 2014 17:44:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, gong.chen@linux.intel.com,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel@stlinux.com, eric.paire@st.com
Subject: Re: [PATCH v3] bitops: Fix shift overflow in GENMASK macros
Message-ID: <20141105164454.GY3337@twins.programming.kicks-ass.net>
References: <1415098697-16304-1-git-send-email-maxime.coquelin@st.com>
 <87vbmt52dm.fsf@rasmusvillemoes.dk>
 <545A4682.2080302@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545A4682.2080302@st.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:47:14PM +0100, Maxime Coquelin wrote:
> 
> On 11/05/2014 12:10 PM, Rasmus Villemoes wrote:
> >On Tue, Nov 04 2014, Maxime COQUELIN <maxime.coquelin@st.com> wrote:
> >
> >>-#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
> >>-#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
> >>+#define GENMASK(h, l) \
> >>+	((~0UL >> (BITS_PER_LONG - ((h) - (l) + 1))) << (l))
> >>+
> >>+#define GENMASK_ULL(h, l) \
> >>+	((~0ULL >> (BITS_PER_LONG_LONG - ((h) - (l) + 1))) << (l))
> >Slightly bikeshedding here, but may I suggest spelling it
> >
> >   (((~0UL) << (l)) & (~0UL >> (BITS_PER_LONG - 1 - (h))))
> >
> >? This will ensure the arguments are expanded once each, and will, IMHO,
> >DTRT if/when l > h (namely, yield 0).
> That's a good point.
> 
> Peter, what is your view?

I'm fine with that, feel free to post another version and I'll replace
v3.
