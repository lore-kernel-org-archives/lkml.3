Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3GOStp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:49:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10963 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3GOSto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:49:44 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=0OGBnBv_dtgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ringC-sgREwA:10 a=vTr9H3xdAAAA:8 a=CUcPWZCSape_4CGI3AMA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373914182.17876.165.camel@gandalf.local.home>
Subject: Re: nohz: Warn if the machine can not perform nohz_full
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 15 Jul 2013 14:49:42 -0400
In-Reply-To: <20130715173848.GA1066@redhat.com>
References: <20130715170859.GA25570@redhat.com>
	 <20130715171800.GD6442@somewhere> <20130715172423.GA27745@redhat.com>
	 <20130715173848.GA1066@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 13:38 -0400, Dave Jones wrote:
> On Mon, Jul 15, 2013 at 01:24:23PM -0400, Dave Jones wrote:
>  > On Mon, Jul 15, 2013 at 07:18:02PM +0200, Frederic Weisbecker wrote:
>  >  
>  >  > > So I guess you guys never want this to be enabled on distro kernels ?
>  >  > > If that's the case, can you add something to that effect in Kconfig ?
>  >  > 
>  >  > I believe we want it to be enabled on distros in the long term. But right now it would
>  >  > be a bad idea until the off case (nohz_full= parameter empty) is carefully optimized.
>  >  > I'm currently working on that.
>  >  > 
>  >  > Now for the unstable tsc, which is what it's about on the above code block, we need
>  >  > the tick to be there to leverage the sched clock madness. May be there could be some
>  >  > other solution that could work along full dynticks but for now we chose the easy path.
>  >  > 
>  >  > Are broken TSCs that common?
>  >  
>  > I just hit one apparently.  http://paste.fedoraproject.org/25421/73907845/raw/
>  > That's a fairly recent Atom board, so I suspect it's not uncommon on that platform.
> 
> And here's a Core Duo from circa 2008.
> http://paste.fedoraproject.org/25429/13739098/raw
> 
> Two for two so far. I get the feeling you guys are going to get a ton of these reports.
> 

Hmm, we should only warn if the user tried to enable nohz-full via the
command line. But it looks like it warns even without enabling
nohz-full, which wasn't the desired effect.

I'll look at this, and send a patch to make sure the warning only
happens when the user tries to use nohz-full, and doesn't just compile
it in. The point of the patch is to not let the user think they have
nohz-full when they don't.

-- Steve


