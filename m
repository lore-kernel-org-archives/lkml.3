Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaJ0VWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:22:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbaJ0VWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:22:17 -0400
Date: Mon, 27 Oct 2014 17:22:06 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        przanoni@gmail.com, mingo@kernel.org, hpa@linux.intel.com,
        hpa@zytor.com, linux-tip-commits@vger.kernel.org,
        linux-audit@redhat.com
Subject: Re: [PATCH] i386/audit: stop scribbling on the stack frame
Message-ID: <20141027212206.GE15532@madcap2.tricolour.ca>
References: <1414037043-30647-1-git-send-email-eparis@redhat.com>
 <tip-26c2d2b39128adba276d140eefa2745591b88536@git.kernel.org>
 <alpine.DEB.2.11.1410251034320.5308@nanos>
 <20141027023457.GY15532@madcap2.tricolour.ca>
 <1414418157.24347.1.camel@redhat.com>
 <alpine.DEB.2.11.1410272212420.5308@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410272212420.5308@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/27, Thomas Gleixner wrote:
> On Mon, 27 Oct 2014, Eric Paris wrote:
> > My patch was already committed to the -tip urgent branch.  I believe any
> > optimization should be based on that branch, Richard.  If you are trying
> > to wrangle every bit of speed out of this, should you
> > 
> > push %esi;
> > push %edi;
> > CFI_ADJUST_CFA_OFFSET 8
> 
> Wrong. You want to use pushl_cfi as you need the CFI adjustment after
> each modification of esp.
> 
> > call __audit_syscall_entry
> > pop;
> > pop;
> > CFI_ADJUST_CFA_OFFSET -8
> > 
> > Instead of using the pushl_cfi and popl_cfi macros?
> 
> Wrong again. See above. Aside of that, why do you want to use pop at
> all? All we care about is adjusting esp, right?

Right.  We don't care about those two values on the bottom of the stack.
Just move the extended stack pointer and adjust CFI.

> Thanks,
> 
> 	tglx

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
