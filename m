Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaKKTzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:55:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:11797 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbaKKTzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:55:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414976417"
Message-ID: <1415735698.21508.4.camel@theros.lm.intel.com>
Subject: Re: [PATCH 3/6] x86: Add support for the clwb instruction
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Date: Tue, 11 Nov 2014 12:54:58 -0700
In-Reply-To: <20141111194621.GB12555@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1415731396-19364-4-git-send-email-ross.zwisler@linux.intel.com>
	 <20141111191239.GC31523@pd.tnic> <20141111191904.GA12555@pd.tnic>
	 <1415734800.21508.0.camel@theros.lm.intel.com>
	 <20141111194621.GB12555@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20.rez) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 20:46 +0100, Borislav Petkov wrote:
> On Tue, Nov 11, 2014 at 12:40:00PM -0700, Ross Zwisler wrote:
> > Yep, it's weird, I know.  :)
> 
> But sure, saving opcode space, makes sense to me.
> 
> Btw, I'd still be interested about this:
> 
> > +static inline void clwb(volatile void *__p)
> > +{
> > +     alternative_io_2(".byte " __stringify(NOP_DS_PREFIX) "; clflush %P0",
> 
> Any particular reason for using 0x3e as a prefix to have the insns be
> the same size or is it simply because CLFLUSH can stomach it?

Ah, sorry, I was still responding to your first mail.  :)  Response
copied here to save searching:

        Essentially we need one additional byte at the beginning of the
        clflush so that we can flip it into a clflushopt by changing that byte
        into a 0x66 prefix.  Two options are to either insert a 1 byte
        ASM_NOP1, or to add a 1 byte NOP_DS_PREFIX.  Both have no functional
        effect with the plain clflush, but I've been told that executing a
        clflush + prefix should be faster than executing a clflush + NOP.

I agree, this is useful info - I'll add it to the patch comments for v2.

Thank you for the feedback.

- Ross

