Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaIYKO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:14:29 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37219 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaIYKO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:14:27 -0400
Date: Thu, 25 Sep 2014 11:14:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kyle McMartin <kyle@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] aarch64: filter $x from kallsyms
Message-ID: <20140925101417.GG10390@e104818-lin.cambridge.arm.com>
References: <20140916213718.GR22012@redacted.bos.redhat.com>
 <87r3z9o91q.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r3z9o91q.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 05:18:57AM +0100, Rusty Russell wrote:
> Kyle McMartin <kyle@redhat.com> writes:
> > Similar to ARM, AArch64 is generating $x and $d syms... which isn't
> > terribly helpful when looking at %pF output and the like. Filter those
> > out in kallsyms, modpost and when looking at module symbols.
> >
> > Seems simplest since none of these check EM_ARM anyway, to just add it
> > to the strchr used, rather than trying to make things overly
> > complicated.
> >
> > initcall_debug improves:
> > dmesg_before.txt: initcall $x+0x0/0x154 [sg] returned 0 after 26331 usecs
> > dmesg_after.txt: initcall init_sg+0x0/0x154 [sg] returned 0 after 15461 usecs
> >
> > Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks. Shall I understand that you are ok for me to take it via the
arm64 tree (or you'd prefer to merge it via your tree)?

-- 
Catalin
