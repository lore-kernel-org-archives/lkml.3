Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab3GLBvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:51:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7142 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab3GLBvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:51:12 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=E3gBSPWCDXAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=Ll2u-3dKkrkwbACT3mwA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373593870.17876.70.camel@gandalf.local.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, ksummit-2013-discuss@lists.linuxfoundation.org
Date: Thu, 11 Jul 2013 21:51:10 -0400
In-Reply-To: <20130711224455.GA17222@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 15:44 -0700, Greg Kroah-Hartman wrote:

> > For .10 I had to start making a list of "shit that's broken that there's
> > an outstanding patch for" and nagging people to send them week after week.
> > Every time I reported a new bug I'd hit, I'd have to explain I wasn't running
> > Linus' tree because there was so much other crap I had to carry just to
> > get things to a baseline of stability before starting tests.
> > 
> > By rc7 things got a lot better, but if we have fixes sitting around in
> > git trees for weeks on end with no progress, that kinda sucks.
> 
> We have patches with assigned CVE numbers sitting in subsystem trees
> that didn't hit Linus's tree until this merge window.  Now granted, I
> don't necessarily agree that they were worth CVEs, but really, holding
> them off from being merged for 2 months or so is really bad, and means
> that something seems a bit broken with our development process.
> 
> And thanks for nagging people, I really appreciate it, sad it's
> necessary.

What I try to do is, get all "stable" patches in before -rc4 is out.
Once -rc4 is out, then I get a bit more picky with what to push to
Linus. If it's not a regression (something that's been broken for a
while) I don't push it. -rc5, I get even pickier, and by -rc6 and
beyond, I only push things that may crash the kernel. If things just
give bad output (for tracing), I tag it with stable and wait for the
merge window.

3.10 was actually really bad for me. I had some major changes done to
ftrace, and there were a lot of patches sent to me after -rc4 came out.
A lot of them were nits and didn't crash the kernel, thus I only tagged
them with stable. Some of them, we didn't get correct until Linus opened
the merge window.

Maybe this would be a good KS topic. What exactly is appropriate to push
during the -rc's. Perhaps have criteria for the -rc levels.

-rc1-3, take all bug fixes.

-rc4,5, regressions, and more substantial bugs

-rc6-..  get your act together. Only critical bug fixes.

??

-- Steve


