Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab3BSEl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 23:41:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16897 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab3BSElY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 23:41:24 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8jnvGVjTqY4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_67WK3i7ub8A:10 a=ZsDOa8PpoTLVNZjxooAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1361248883.23152.199.camel@gandalf.local.home>
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
Date: Mon, 18 Feb 2013 23:41:23 -0500
In-Reply-To: <512301F7.4020709@zytor.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C4B@USINDEM103.corp.hds.com>
	    <511ECE53.8040801@zytor.com>
	   <1360979993.23152.122.camel@gandalf.local.home>
	   <511EEAE1.1040106@zytor.com>
	  <1360981364.23152.123.camel@gandalf.local.home>
	  <A5ED84D3BB3A384992CBB9C77DEDA4D414ABE178@USINDEM103.corp.hds.com>
	  <5122BE0C.9020403@zytor.com>
	 <1361247854.23152.198.camel@gandalf.local.home>
	 <512301F7.4020709@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 20:39 -0800, H. Peter Anvin wrote:

> > static void switch_to_trace_idt(void *arg)
> > {
> >      load_idt(&trace_idt_descr);
> > }
> > 
> > static void restore_original_idt(void *arg)
> > {
> >      load_idt(this_cpu_ptr(&idt_descr));
> > }
> > 
> 
> Yes.  If there needs to be handshaking about whose IDT is currently
> installed I'm much happier if that handshake is done explicitly, rather
> than as a save/restore function which will break when we have to add
> another one which for whatever reason isn't nesting.

Agreed.

Seiji, can you make the update?

Thanks,

-- Steve


