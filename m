Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaCFRXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:23:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaCFRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:23:11 -0500
Date: Thu, 6 Mar 2014 18:22:17 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/3] perf tests: Introduce perf_regs_load function on ARM
Message-ID: <20140306172217.GB1269@krava.brq.redhat.com>
References: <1393840403-26639-1-git-send-email-jean.pihet@linaro.org>
 <1393840403-26639-2-git-send-email-jean.pihet@linaro.org>
 <20140304110042.GD8766@mudshark.cambridge.arm.com>
 <CAFrcx1=3+zZPErXC7dehwpKHnmwE=cWh1mR0kzN0PONpFZKaUw@mail.gmail.com>
 <20140306113314.GD5202@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306113314.GD5202@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 11:33:15AM +0000, Will Deacon wrote:
> On Wed, Mar 05, 2014 at 02:17:00AM +0000, Jean Pihet wrote:
> > On 4 March 2014 12:00, Will Deacon <will.deacon@arm.com> wrote:
> > > On Mon, Mar 03, 2014 at 09:53:21AM +0000, Jean Pihet wrote:
> > >> +     str lr, [r0, #PC]       @ Save caller PC
> > >
> > > This isn't necessarily the `caller PC' (depending on how you define it).
> > > It's the return address, which is probably (but not always) the instruction
> > > following the branch to this function.
> > Agreed. However the perf test code expects a registers buffer filled
> > in with the caller's values.
> > I can change the comment here, is that needed?
> 
> It depends what the perf test code really expects. At the moment, you're not
> providing it with anything consistent which doesn't sound correct.

the code expects caller's PC. That is what the x86 test code
expects from perf_regs_load. We take the return IP saved by
call instruction:

ENTRY(perf_regs_load)
	...
	movq 0(%rsp), %rax
	movq %rax, IP(%rdi)
	...

jirka
