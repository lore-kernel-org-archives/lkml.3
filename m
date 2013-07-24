Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3GXSqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:46:05 -0400
Received: from smtpauth05.mfg.siteprotect.com ([64.26.60.144]:55237 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024Ab3GXSqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:46:01 -0400
Date: Wed, 24 Jul 2013 14:47:03 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andi Kleen <andi@firstfloor.org>
cc: Andi Kleen <ak@linux.intel.com>, acme@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org,
        trinity@vger.kernel.org
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
In-Reply-To: <20130723225150.GT6123@two.firstfloor.org>
Message-ID: <alpine.DEB.2.02.1307241433380.8230@pianoman.cluster.toy>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org> <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy> <20130723060108.GA18396@tassilo.jf.intel.com> <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
 <20130723225150.GT6123@two.firstfloor.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020209.51F020E9.007A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013, Andi Kleen wrote:

> On Tue, Jul 23, 2013 at 05:27:43PM -0400, Vince Weaver wrote:
> > 

> So format/precise would be 
> 
> flags:15-16
> 
> on little endian. Looks good?

I'd prefer if it were

  precise_ip:0-1

as the code you use to set the value looks like 
   attr->precise_ip=2;
I don't think you can even set bits 15-16 of flags directly, can you?

Althought having to have a parser being able to parse the names of all 50+
perf_event->attr arguments, then parse hex/decimal strings from another
file in sysfs, then trying to map that to binary fields in a complicated
structure that is then passed to a syscall gets a bit stupid at some 
point; this is one of the silliest interfaces I've had to deal with and 
I've done low-level X11 programming before.

Ideally we could do something sane, such as maybe having the event 
descriptions in a library in userspace where it belongs but it's a bit
late to close the barn door now.

> > I'm a bit grumpy about this because I just finished fixing the fallout 
> > from your last time breaking the ABI a few weeks ago when your broken code 
> > started dumping non-hex fields into the sysfs event strings.  I've learned 
> 
> Not sure what you're talking about?

I'm pretty sure it was one of your patches that added the new memory stuff 
which had "ldlat=1" in one of the events, and that was not a hex value 
prefixed by 0x as specified in the ABI documentation and thus broke
various parsers.

By the time I caught this the perf_event maintainers declared it was too 
late to do anything about it.

Vince
