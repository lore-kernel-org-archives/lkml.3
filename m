Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbaJaJJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:09:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:39135 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaJaJJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:09:27 -0400
Date: Fri, 31 Oct 2014 10:09:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ren Qiaowei <qiaowei.ren@intel.com>
cc: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH v9 09/12] x86, mpx: decode MPX instruction to get bound
 violation information
In-Reply-To: <5452EFF7.4090204@intel.com>
Message-ID: <alpine.DEB.2.11.1410311007230.5308@nanos>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com> <1413088915-13428-10-git-send-email-qiaowei.ren@intel.com> <5452BDD8.2080605@intel.com> <5452EFF7.4090204@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Ren Qiaowei wrote:
> On 10/31/2014 06:38 AM, Dave Hansen wrote:
> > > @@ -316,6 +317,11 @@ dotraplinkage void do_bounds(struct pt_regs *regs,
> > > long error_code)
> > >   		break;
> > > 
> > >   	case 1: /* Bound violation. */
> > > +		do_mpx_bounds(regs, &info, xsave_buf);
> > > +		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs,
> > > +				error_code, &info);
> > > +		break;
> > > +
> > >   	case 0: /* No exception caused by Intel MPX operations. */
> > >   		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code,
> > > NULL);
> > >   		break;
> > > 
> > 
> > So, siginfo is stack-allocarted here.  do_mpx_bounds() can error out if
> > it sees an invalid bndregno.  We still send the signal with the &info
> > whether or not we filled the 'info' in do_mpx_bounds().
> > 
> > Can't this leak some kernel stack out in the 'info'?
> > 
> 
> This should check the return value of do_mpx_bounds and should be fixed.

And how's that answering Dave's question about leaking stack information? 

Thanks,

	tglx
