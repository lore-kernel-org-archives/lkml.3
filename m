Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab3B1SOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:14:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759993Ab3B1SOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:14:15 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=QjT1mVhjSf4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=ev9wIl1RTScA:10 a=zbbTrqVcxftZtKoRw0QA:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Thu, 28 Feb 2013 13:14:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, mingo@redhat.com,
        tglx@linutronix.de, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, jwboyer@redhat.com
Subject: Re: Is: x86: mm: Fix vmalloc_fault oops during lazy MMU updates Was:
 Re: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
Message-ID: <20130228181411.GD9161@home.goodmis.org>
References: <512E8B41.8000504@zytor.com>
 <20130227230009.GA32465@kroah.com>
 <512E91B7.6060102@zytor.com>
 <20130228142910.GA32354@phenom.dumpdata.com>
 <20130228153846.GA9782@pd.tnic>
 <512F7D88.4090703@zytor.com>
 <20130228161057.GC9767@pd.tnic>
 <512F83C4.6080904@oracle.com>
 <20130228162227.GD9767@pd.tnic>
 <512F856B.5090801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512F856B.5090801@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 11:27:23AM -0500, Boris Ostrovsky wrote:
> On 02/28/2013 11:22 AM, Borislav Petkov wrote:
> >On Thu, Feb 28, 2013 at 11:20:20AM -0500, Boris Ostrovsky wrote:
> >>On 02/28/2013 11:10 AM, Borislav Petkov wrote:
> >>>On Thu, Feb 28, 2013 at 07:53:44AM -0800, H. Peter Anvin wrote:
> >>>>At the very least we should have an early filter for the **COMMON!**
> >>>>case that we are not on a PV platform.
> >>>... or, patch it out with the alternatives on baremetal, as Steven
> >>>suggested.
> 
> What was the suggestion exactly? I don't remember seeing that message.

Yeah, Borislav talked to me privately on IRC about this and I pointed
him to the apply_paravirt() function in arch/x86/kernel/alternative.c
where things that apply only to paravirt get patched out on baremetal.

It may add complexity, but there's a method for doing it and I rather
not burden baremetal for pravirt nonsense. I know adding a simple call
to preempt_count() can show a noticable impact to function tracing. It
requires referencing the gs segment register and doing some offset
games (as it's stored as a per cpu pointer) to find the stack.

I was actually a bit amazed that it had as big of an impact as it did. I
can understand why Christoph Lameter tried hard not to add a
preempt_disable() in his code for just a tiny location.

-- Steve

> 
> -boris
> 
> >>>
> >>I think making a check for paravirt_enabled() is safe enough. I'll
> >>send a patch shortly.
> >Why not make it absolutely for free?
> >
