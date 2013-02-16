Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab3BPB75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 20:59:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21125 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3BPB7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 20:59:55 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8jnvGVjTqY4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_67WK3i7ub8A:10 a=D19gQVrFAAAA:8 a=ayC55rCoAAAA:8 a=m0D0claWAAAA:8 a=SPH_4gJ0RUGj5DSuxwMA:9 a=PUjeQqilurYA:10 a=E6k37eg1NvgA:10 a=Yd2lsRJ0m1XkGSSk:21 a=mhl9jSTqzmc_QqwC:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360979993.23152.122.camel@gandalf.local.home>
Subject: Re: [PATCH v9 2/3] trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Date: Fri, 15 Feb 2013 20:59:53 -0500
In-Reply-To: <511ECE53.8040801@zytor.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C4B@USINDEM103.corp.hds.com>
	 <511ECE53.8040801@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 16:09 -0800, H. Peter Anvin wrote:
> On 02/04/2013 02:49 PM, Seiji Aguchi wrote:
> > +
> > +static void switch_to_trace_idt(void *arg)
> > +{
> > +	store_idt(this_cpu_ptr(&orig_idt_descr));
> > +	load_idt(&trace_idt_descr);
> > +
> > +	return;
> > +}
> > +
> > +static void restore_original_idt(void *arg)
> > +{
> > +	if (this_cpu_read(orig_idt_descr.address)) {
> > +		load_idt(this_cpu_ptr(&orig_idt_descr));
> > +		this_cpu_write(orig_idt_descr.address, 0);
> > +	}
> > +
> > +	return;
> > +}
> > +
> 
> The base address of the IDT doesn't generally change... the one
> exception is when we do the funny NMI workaround.
> 
> For that reason, I would be happier if we just restored the standard
> value instead of saving/restoring stuff.
> 
> The above code is probably broken if either side is in the funny NMI
> zone... unless you can guarantee it is *always* in the funny NMI zone
> (in which case you can just load nmi_idt_descr instead.
> 
> Steve R., do you know what the constraints are with respect to that?
> 

This switch should always be outside the funny NMI and debug zone.
I think you missed a patch that I sent you to deal with exactly this:

https://lkml.org/lkml/2013/2/1/532

I sent it directly to you, maybe it got buried in your INBOX.

-- Steve


