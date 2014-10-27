Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaJ0R37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:29:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbaJ0R36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:29:58 -0400
Message-ID: <1414430984.24347.6.camel@redhat.com>
Subject: Re: [PATCH] i386/audit: stop scribbling on the stack frame
From: Eric Paris <eparis@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, przanoni@gmail.com, mingo@kernel.org,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org,
        linux-audit@redhat.com
Date: Mon, 27 Oct 2014 13:29:44 -0400
In-Reply-To: <544E7A8D.1030909@zytor.com>
References: <1414037043-30647-1-git-send-email-eparis@redhat.com>
		 <tip-26c2d2b39128adba276d140eefa2745591b88536@git.kernel.org>
		 <alpine.DEB.2.11.1410251034320.5308@nanos>
		 <20141027023457.GY15532@madcap2.tricolour.ca>
	 <1414418157.24347.1.camel@redhat.com> <544E7A8D.1030909@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 10:02 -0700, H. Peter Anvin wrote:
> On 10/27/2014 06:55 AM, Eric Paris wrote:
> > My patch was already committed to the -tip urgent branch.  I believe any
> > optimization should be based on that branch, Richard.  If you are trying
> > to wrangle every bit of speed out of this, should you
> > 
> > push %esi;
> > push %edi;
> > CFI_ADJUST_CFA_OFFSET 8
> > call __audit_syscall_entry
> > pop;
> > pop;
> > CFI_ADJUST_CFA_OFFSET -8
> > 
> > Instead of using the pushl_cfi and popl_cfi macros?
> > 
> > I wrote my patch to be obviously correct, but agree there are certainly
> > some speedups possible.
> > 
> 
> Uh... not only is that plain wrong (the CFI should be adjusted after
> each instruction that changes the stack pointer),

Sure, things would be screwed up between the two push's

>  but what the heck is
> wrong with using the macros?

I was asking if that would save an instruction or two by consolidating
the CFI update and if so would that tradeoff be worth it, given the
regularity of this code being run.

> 
> 	-hpa
> 
> 
> 


