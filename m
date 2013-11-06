Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3KFSDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:03:52 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46403 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755228Ab3KFSDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:03:51 -0500
Date: Wed, 6 Nov 2013 18:02:41 +0000
From: Will Deacon <will.deacon@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiang Liu <liuj97@gmail.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] arm64: introduce
 aarch64_insn_gen_{nop|branch_imm}() helper functions
Message-ID: <20131106180241.GB4524@mudshark.cambridge.arm.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
 <1382109602-27432-5-git-send-email-liuj97@gmail.com>
 <20131030004840.GC25346@mudshark.cambridge.arm.com>
 <20131106114530.76b63b05@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106114530.76b63b05@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 04:45:30PM +0000, Steven Rostedt wrote:
> On Wed, 30 Oct 2013 00:48:40 +0000
> Will Deacon <will.deacon@arm.com> wrote:
> 
> 
> > > +}
> > > +
> > > +static __always_inline u32 aarch64_insn_gen_nop(void)
> > > +{
> > > +	return aarch64_insn_gen_hint(AARCH64_INSN_HINT_NOP);
> > > +}
> > 
> > Either use plain old `inline' or write these as preprocessor macros.
> > 
> 
> I'm curious to why you say that? Preprocessor macros are rather ugly,
> and in x86 we use "__always_inline" quite liberally.

I can understand why you might use __always_inline over the preprocessor
when you *really* need something inlined, but in this case I don't see why
`inline' isn't sufficient. It's just a cosmetic issue, really.

Will
