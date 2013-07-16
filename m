Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab3GPBDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:03:50 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60443 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543Ab3GPBDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:03:49 -0400
Date: Tue, 16 Jul 2013 03:03:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rostedt@goodmis.org
Subject: Re: nohz: Warn if the machine can not perform nohz_full
Message-ID: <20130716010344.GC13562@somewhere>
References: <20130715170859.GA25570@redhat.com>
 <20130715171800.GD6442@somewhere>
 <20130715172423.GA27745@redhat.com>
 <20130715173848.GA1066@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715173848.GA1066@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 01:38:48PM -0400, Dave Jones wrote:
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

Definetly, so it comforts me on the fact we need to remove the warning, which may be
interpreted as the symptom of a bug to report while it's not.

We need to warn the user but through another way.
