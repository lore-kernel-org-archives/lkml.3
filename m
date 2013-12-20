Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab3LTQLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:11:08 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:58841 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780Ab3LTQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:11:06 -0500
Message-ID: <1387555822.3404.79.camel@linaro1.home>
Subject: Re: [PATCH v3 00/15] uprobes: Add uprobes support for ARM
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Linaro Networking <linaro-networking@linaro.org>
Date: Fri, 20 Dec 2013 16:10:22 +0000
In-Reply-To: <52A0DF6A.1010402@linaro.org>
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
	 <529F6B88.2050005@linaro.org> <52A0DF6A.1010402@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 15:17 -0500, David Long wrote:
> Masami/Tixy,
> 
> As I just noted in a previous email the kprobes.h thing has come back to 
> haunt me.  Something more is needed in my last patchset.  Tixy's 
> suggestion regarding the arch_specific_insn structure:
> 
> > However, I also wonder if we should instead leave arch_specific_insn as
> > a kprobes specific structure and on ARM define it in terms of a new more
> > generic 'struct probe_insn'? The drawback with that is that we'd
> > probably end up with a struct just containing a single member which
> > seems a bit redundant:
> >
> > struct arch_specific_insn {
> > 	struct probe_insn pinsn;
> > };
> >
> > Thought's anyone?
> 
> ...got me thinking.  When I do as he suggests and create a new 
> arch-specific structure for sharing between kprobes and uprobes then it 
> turns out simply #define'ing the arch_specific_insn structure tag to the 
> new structure tag in arch/arm/include/kprobes.h makes everything happy. 
>   When KPROBES is not configured that include file is (still) not 
> included and the generic kprobes.h include file still continues to make 
> a dummy structure for it.  My question is:  Is it too hacky to use a 
> #define for a structure tag this way?

I can't think of any technical reason why this wouldn't work and I see
you've have implemented this method in the latest uprobes patches [1].

It does mean that would be able to progress with ARM uprobes if there is
no immediate enthusiasm for making kprobes/uprobes more unified at the
generic kernel layers.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/219463.html

-- 
Tixy


