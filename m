Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaFYJBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:01:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33795 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703AbaFYJBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:01:43 -0400
Date: Wed, 25 Jun 2014 10:01:10 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Sneha Priya <sneha.cse@hotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: perf: allow tracing with kernel tracepoints events
Message-ID: <20140625090110.GD6153@arm.com>
References: <CAFrcx1n-cPXm=w+84gQiUjZoFKi7gYnvJ0BQ+8yXKS=k3nEt3g@mail.gmail.com>
 <1403025065-18001-1-git-send-email-jean.pihet@linaro.org>
 <20140618125355.GA2186@arm.com>
 <CAFrcx1mA7kXiG9wMQqn=zYPYqrpGxDYWfoMP97RvkkrMTvNoRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1mA7kXiG9wMQqn=zYPYqrpGxDYWfoMP97RvkkrMTvNoRw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 09:10:35AM +0100, Jean Pihet wrote:
> Hi Will,

Hi Jean,

> On 18 June 2014 14:53, Will Deacon <will.deacon@arm.com> wrote:
> > On Tue, Jun 17, 2014 at 06:11:05PM +0100, Jean Pihet wrote:
> >> Tested with perf record and tracepoints filtering (-e <tracepoint>), with
> >> unwinding using fp (--call-graph fp) and dwarf info (--call-graph dwarf).
> >
> > Whilst the old ACPS unwinding only needs PC, FP and SP, is this definitely
> > true for exidx and DWARF-based unwinding? Given that libunwind ends up
> > running a state machine for the latter, can we guarantee that we won't hit
> > instructions that require access to other general purpose registers?
> Yes. dwarf unwinding does not need anything extra. Once seeded all the
> rest is extracted from the dwarf trace info.

Ok, but what if the LR isn't saved on the stack, for example? What if the
code you're trying to unwind is hand-written assembly annotated with CFI
directives?

Will
