Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaEAXgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:36:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54169 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaEAXgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:36:24 -0400
Subject: Re: [PATCHv4] uprobes: simplify rip-relative handling
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
In-Reply-To: <20140501185058.GA17450@redhat.com>
References: <1398955966-7771-1-git-send-email-dvlasenk@redhat.com>
	 <20140501185058.GA17450@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 May 2014 16:35:23 -0700
Message-ID: <1398987323.4908.5.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050123-0928-0000-0000-000001A19EC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-01 at 20:50 +0200, Oleg Nesterov wrote:
> Thanks, I hope that Jim's ack still applies to this version.

Yes.  v4 looks fine, although Oleg has a good point about moving the
comment.  But I'd move more of the comment, starting with
 * We have to fix things up as follows:

Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>


> On 05/01, Denys Vlasenko wrote:
> >
> > v4: Changed arch_uprobe_xol_was_trapped() comment to reflect new logic.
> 
> Hmm. I guess you meant arch_uprobe_post_xol()... please see below.
> 
> >  static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
> >  {
> >  	struct uprobe_task *utask = current->utask;
> > -	long correction = (long)(utask->vaddr - utask->xol_vaddr);
> >  
> > -	riprel_post_xol(auprobe, regs, &correction);
> > +	riprel_post_xol(auprobe, regs);
> >  	if (auprobe->def.fixups & UPROBE_FIX_IP) {
> > +		long correction = (long)(utask->vaddr - utask->xol_vaddr);
> 
> Can't resist, I'll remove this pointless cast ;)
> 
> >   * If the original instruction was a rip-relative instruction such as
> >   * "movl %edx,0xnnnn(%rip)", we have instead executed an equivalent
> > - * instruction using a scratch register -- e.g., "movl %edx,(%rax)".
> > - * We need to restore the contents of the scratch register and adjust
> > - * the ip, keeping in mind that the instruction we executed is 4 bytes
> > - * shorter than the original instruction (since we squeezed out the offset
> > - * field).  (FIX_RIP_AX or FIX_RIP_CX)
> > + * instruction using a scratch register -- e.g., "movl %edx,0xnnnn(%rax)".
> > + * We need to restore the contents of the scratch register
> > + * (FIX_RIP_AX or FIX_RIP_CX).
> >   */
> >  int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> 
> Perhaps it makes sense to move this part of the comment above
> default_post_xol_op() which actually does this...
> 
> I won't insist, I do not really care because I almost never read the comments
> anyway ;)
> 
> Oleg.
> 


