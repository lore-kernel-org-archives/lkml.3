Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab3FDU6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:58:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12574 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3FDU6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:58:13 -0400
X-Authority-Analysis: v=2.0 cv=Et5QXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=8UkHzMSrflQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=ITzkURZ2-D4A:10 a=scEZ3zhL6hPtsaF1EPsA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370379489.9844.7.camel@gandalf.local.home>
Subject: Re: [PATCH v13 3/3] trace,x86: Add irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "bp@alien8.de" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Date: Tue, 04 Jun 2013 16:58:09 -0400
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41B011681@USINDEM103.corp.hds.com>
References: <51ACEDBB.6040706@hds.com> <51ACEEB4.1010302@hds.com>
	 <1370303581.26799.109.camel@gandalf.local.home>
	 <51AE2EDF.3000505@zytor.com> <1370370763.9844.6.camel@gandalf.local.home>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D41B011681@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-04 at 20:20 +0000, Seiji Aguchi wrote:
> Steven,
> 
> > 
> > Hmm, maybe we can do it. Have two counters, a debug_idt_ctr and a
> > trace_idt_ctr, then have a function that basically does this:
> > 
> > 	if (this_cpu_read(debug_idt_ctr))
> 
> I think we can use "debug_stack_use_ctr"  for the checking.
> Is it correct?
> Or, do I need to introduce a new debug_idt_ctr?
> 

No, it's the same variable. I was thinking we should rename it too, as
debug_stack_use_ctr, doesn't really describe what is happening anymore.

-- Steve


