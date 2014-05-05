Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaEEGAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 02:00:37 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49143 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbaEEGAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 02:00:36 -0400
Subject: Re: [PATCH] uprobes: fix scratch register selection for
 rip-relative fixups
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <5363B3E8.6020606@redhat.com>
References: <1398964141-25097-1-git-send-email-dvlasenk@redhat.com>
	 <1398991682.4908.22.camel@oc7886638347.ibm.com.usor.ibm.com>
	 <5363B3E8.6020606@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 May 2014 23:00:24 -0700
Message-ID: <1399269624.5603.3.camel@oc7886638347.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050506-5806-0000-0000-000024CA9651
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 17:04 +0200, Denys Vlasenko wrote:
> On 05/02/2014 02:48 AM, Jim Keniston wrote:
> > On Thu, 2014-05-01 at 19:09 +0200, Denys Vlasenko wrote:
> >> +#define VEX2_VVVV(insn)		X86_VEX_V((insn)->vex_prefix.bytes[1])
> >> +#define VEX3_VVVV(insn)		X86_VEX_V((insn)->vex_prefix.bytes[2])
> > 
> > I disclaim any knowledge about VEX* stuff.
> ...
> > skipped this next part...
> > 
> >> +	/* Similar treatment for VEX3 prefix */
> >> +	/* TODO: add XOP/EVEX treatment when insn decoder supports them */
> >> +	if (insn->vex_prefix.nbytes == 3) {
> >> +		/*
> >> +		 * vex2:     c5    rvvvvLpp   (has no b bit)
> >> +		 * vex3/xop: c4/8f rxbmmmmm wvvvvLpp
> >> +		 * evex:     62    rxbR00mm.wvvvv1pp.zllBVaaa
> >> +		 *   (evex will need setting of both b and x since
> >> +		 *   in non-sib encoding evex.x is 4th bit of MODRM.rm)
> >> +		 * Setting VEX3.b (setting because it has inverted meaning):
> >> +		 */
> >> +		cursor = auprobe->insn + insn_offset_vex_prefix(insn) + 1;
> >> +		*cursor |= 0x20;
> >>  	}
> > 
> > ... resumed reviewing here.
> 
> I do realize that most people reading this code won't be
> aficionados of memorizing x86 insn encoding quirks.
> 
> To help them, I added the comment which spells out bit layout
> of vex/evex/xop prefixes (see above). Does it help?
> 
...

Well, yes.  I read your comments in conjunction with the "VEX Prefix"
wikipedia page and figured out what you're doing, and it looks right.  I
would definitely leave the comments in; otherwise there's a chance that
even you won't remember all this stuff 6 months from now.

Jim

