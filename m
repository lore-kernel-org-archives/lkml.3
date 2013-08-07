Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3HGFNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:13:06 -0400
Received: from popelka.ms.mff.cuni.cz ([195.113.20.131]:54214 "EHLO
	popelka.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3HGFNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:13:04 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Aug 2013 01:13:04 EDT
Date: Wed, 7 Aug 2013 07:06:01 +0200
From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130807050601.GA5385@domone.kolej.mff.cuni.cz>
References: <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
 <1375727977.22073.112.camel@gandalf.local.home>
 <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com>
 <1375798783.25420.30.camel@gandalf.local.home>
 <CA+55aFwKYSwytooG50fyryWpVdGEk_v=vdB=L-kAyLmmSW=bkQ@mail.gmail.com>
 <1375811885.25420.44.camel@gandalf.local.home>
 <20130806203319.GA16170@Krystal>
 <1375821817.25420.50.camel@gandalf.local.home>
 <1375836304.25420.76.camel@gandalf.local.home>
 <1375836960.25420.80.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375836960.25420.80.camel@gandalf.local.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 08:56:00PM -0400, Steven Rostedt wrote:
> On Tue, 2013-08-06 at 20:45 -0400, Steven Rostedt wrote:
> 
> > [    3.387362] short jumps: 106
> > [    3.390277]  long jumps: 330
> > 
> > Thus, approximately 25%. Not bad.
> 
> Also, where these happen to be is probably even more important than how
> many. If all the short jumps happen in slow paths, it's rather
> pointless. But they seem to be in some rather hot paths. I had it print
> out where it placed the short jumps too:
> 
 
> The kmem_cache_* and the try_to_wake_up* are the hot paths that caught
> my eye.
> 
> But still, is this worth it?
>
Add short_counter,long_counter and before increment counter before each
jump. That way we will know how many short/long jumps were taken. 
> -- Steve
> 

