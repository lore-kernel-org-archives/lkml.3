Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122Ab3HIPYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 11:24:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965041Ab3HIPYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 11:24:45 -0400
Date: Fri, 9 Aug 2013 11:24:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: Disable at runtime if the kernel enforces module
 signing
Message-ID: <20130809152419.GG12688@redhat.com>
References: <1376033797-24970-1-git-send-email-matthew.garrett@nebula.com>
 <20130809110200.GA9631@redhat.com>
 <1376060830.2021.12.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376060830.2021.12.camel@x230>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 03:07:13PM +0000, Matthew Garrett wrote:
> On Fri, 2013-08-09 at 07:02 -0400, Vivek Goyal wrote:
> > On Fri, Aug 09, 2013 at 03:36:37AM -0400, Matthew Garrett wrote:
> > > kexec permits the loading and execution of arbitrary code in ring 0, which
> > > is something that module signing enforcement is meant to prevent. It makes
> > > sense to disable kexec in this situation.
> > > 
> > 
> > But in the process we wipe out running kernel's context and boot into a new
> > kernel. So how different it is than root booting a new kernel through BIOS
> > which does not enforce module signing.
> 
> What wipes the current kernel's context? KEXEC_JUMP is explicitly
> designed to allow you to hop back and forth, but even without it you
> should be able to reconstruct the original context. And there's no need
> to boot a new kernel, either. All the attacker needs is the physical
> address of the sig_enforce boolean, and then they launch a simple kexec
> payload that simply flips that back and returns to the original kernel -
> it's not like kexec limits you to booting Linux.
> 

Yes, wiping out part is not right. We do some preparation to get ready
to jump to root specified code. Never paid too much of attnetion to
how much work it is to undo what kexec syscall did and reconstruct
the original state.

Thanks
Vivek
