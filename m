Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056Ab3DBSY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:24:59 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64629 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759201Ab3DBSY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:24:58 -0400
Date: Tue, 2 Apr 2013 11:24:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Russell King <linux@arm.linux.org.uk>, msalter@redhat.com,
        starvik@axis.com, David Howells <dhowells@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        takata@linux-m32r.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        james.hogan@imgtec.com, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>, jonas@southpole.se,
        rkuo@codeaurora.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        liqin.chen@sunplusct.com, David Miller <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, vgupta@synopsys.com,
        Chris Zankel <chris@zankel.net>, Chris Metcalf <cmetcalf@tilera.com>,
        ysato@users.sourceforge.jp, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        jdike@addtoit.com
Subject: Re: [PATCH 4/5] dump_stack: implement arch-specific hardware
 description in task dumps
Message-ID: <20130402182452.GB6185@htj.dyndns.org>
References: <1364610428-2074-1-git-send-email-tj@kernel.org>
 <1364610428-2074-5-git-send-email-tj@kernel.org>
 <CAErSpo7Hh7UNkeH=dKrNwPywQZFRfzaX5o7ReUsNvWjM4aD-eA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7Hh7UNkeH=dKrNwPywQZFRfzaX5o7ReUsNvWjM4aD-eA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 01, 2013 at 12:11:17PM -0600, Bjorn Helgaas wrote:
> > +       dump_stack_set_arch_desc("%s %s%s%s", vendor, product,
> > +                                board ? "/" : "", board ? board : "");
> > +}
> 
> Should this be combined or made consistent with dmi_dump_ids()?  They
> look almost the same but not quite (no BIOS version here).

Yeah, that actually would be more useful.  It'd likely be too long
tho.  We can separate it out into its own line which one of the x86
debug paths is doing anyway.  I'll look into it.

Thanks.

-- 
tejun
