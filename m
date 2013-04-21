Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3DURFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 13:05:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab3DURFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 13:05:07 -0400
Date: Sun, 21 Apr 2013 19:02:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf: Add hardware breakpoint address mask
Message-ID: <20130421170202.GA5358@redhat.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com> <20130420165334.GA14814@redhat.com> <20130420224757.GB6155@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130420224757.GB6155@jshin-Toonie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Jacob Shin wrote:
>
> On Sat, Apr 20, 2013 at 06:53:34PM +0200, Oleg Nesterov wrote:
> >
> > And does attr.bp_len "contribute" to the mask?
> >
> > I mean, if bp_len == X86_BREAKPOINT_LEN_8, does this mean that
> > bp_bp_addr_mask and (bp_bp_addr_mask | 7) have the same effect?
>
> Yes it has the same effect.

OK, thanks...

So this is the "natural" extension. Given that currently bp_addr
should be aligned, bp_len could be already bp_mask but I guess it
is too late to change this, so we need another field.

Hmm. Perhaps arch_has_hw_breakpoint_addr_mask(void) should be turned
into arch_validate_hw_breakpoint_addr_mask(bp) which should also
check that (bp_addr & bp_addr_mask) == 0. But I won't insist.

Oleg.

