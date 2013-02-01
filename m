Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab3BAWPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:15:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16869 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab3BAWPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:15:47 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_-1zCJSF_OMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=vw99MyFtH44A:10 a=BQGkFRdVqiR5tP4QpmMA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359756944.5642.50.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH v8 2/3] trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Date: Fri, 01 Feb 2013 17:15:44 -0500
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A5F834@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A508CE@USINDEM103.corp.hds.com>
	 <1359752614.5642.49.camel@gandalf.local.home>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D414A5F834@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-01 at 21:06 +0000, Seiji Aguchi wrote:
> > > +#include <asm/hw_irq.h>
> > > +#include <asm/desc.h>
> > > +
> > > +static struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
> > > +				    (unsigned long) trace_idt_table };
> > > +
> > > +#ifndef CONFIG_X86_64
> > > +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
> > > +					= { { { { 0, 0 } } }, };
> > > +#endif
> > > +
> > > +static struct desc_ptr orig_idt_descr[NR_CPUS];
> > 
> > BTW, this should be:
> > 
> > static DEFINE_PER_CPU(struct desc_ptr, orig_idt_descr);
> > 
> > And look at the patch I made about the NMI/DEBUG trap handling to see how to use it.
> 
> Thanks.
> I'm looking at your patch right now and will update my patch.

Also, don't forget to add the mutex protection that I suggested in
another email.

Thanks,

-- Steve


