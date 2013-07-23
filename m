Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935001Ab3GWWvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:51:55 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53166 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934656Ab3GWWvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:51:53 -0400
Date: Wed, 24 Jul 2013 00:51:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vince Weaver <vince@deater.net>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, torvalds@linux-foundation.org,
        trinity@vger.kernel.org
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
Message-ID: <20130723225150.GT6123@two.firstfloor.org>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
 <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
 <20130723060108.GA18396@tassilo.jf.intel.com>
 <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307231717580.27628@pianoman.cluster.toy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 05:27:43PM -0400, Vince Weaver wrote:
> 
> I hate having to justify why breaking the ABI is unacceptable.

Well it's a testing ABI, so we can do changes to it.

I hope you're not suggesting that perf cannot be extended anymore.
As you know, hardware PMUs are constantly evolving, and perf has evolve
along with them to stay useful.

> It breaks the ABI.  The events/* sysfs files are documented as only 
> holding values for the bitfields described in format/*.

Ok. Need to fix the documentation then for precise=1.  I'll send patches.

Also can add it to format/*, but since it's not in config* it will
be an extension. Since it would be awkward to teach every parser
about all the flags, we could add a "flags" field that is handled 
like config, and contains all the flags.

So format/precise would be 

flags:15-16

on little endian. Looks good?

> I'm a bit grumpy about this because I just finished fixing the fallout 
> from your last time breaking the ABI a few weeks ago when your broken code 
> started dumping non-hex fields into the sysfs event strings.  I've learned 

Not sure what you're talking about?

iirc the only recent sysfs change of mine merged recently was adding
intx/intx_cp, and format files never have had hex numbers in it.

> now that I have to go over your patches with a fine-tooth code because you 
> have no regard for the ABI.

Any useful code review is appreciated.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
