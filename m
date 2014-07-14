Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbaGNPPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:15:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39898 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbaGNPOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:14:49 -0400
Date: Mon, 14 Jul 2014 17:14:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 1/6] x86-mce: Modify CMCI poll interval to adjust for
 small check_interval values.
Message-ID: <20140714151433.GE25115@pd.tnic>
References: <20140709191747.GB5249@pd.tnic>
 <CAFQmdRa5Spr0nX6qwzhDGEU9+H1_0vaCtF_NRV=p=OBDwin78A@mail.gmail.com>
 <20140710114222.GE2970@pd.tnic>
 <CAFQmdRZ1D4OWqkL-zpsiEjuGQaSBBmk36HqSw=q+hHNCRWZCKQ@mail.gmail.com>
 <CA+8MBbJ+FeQKZC9oVZsvrBptaY+24rVKWUXT02ETHMMoA-omuA@mail.gmail.com>
 <CAFQmdRY1=Yg7T15kQmiA+S0j1-xNKsF6Sze49BN7-VzbwW7V4w@mail.gmail.com>
 <20140711153541.GD17083@pd.tnic>
 <CAFQmdRajEjtGB4xXVzCmaUPA=qEjrzQTskJtpmD0cqKhKsEYsg@mail.gmail.com>
 <20140711202207.GC18246@pd.tnic>
 <CAFQmdRavLe6STnBHA0iMJEPxYSFsskFha12T+0AqxV8zd1+ixA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFQmdRavLe6STnBHA0iMJEPxYSFsskFha12T+0AqxV8zd1+ixA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 05:10:07PM -0700, Havard Skinnemoen wrote:
> 200ms per second means we're using 20% of that CPU. I'd say that's
> definitely too much. But I like the general approach.

Right.

> > Yeah, by "generous" I meant, choose values which fit all. But I realize
> > now that this is a dumb idea. Maybe we could measure it on each system,
> > read the TSC on CMCI entry and exit and thus get an average CMCI
> > duration...
> 
> Sounds interesting. Some things that may need some more thought:
> 
> 1. What percentage of CPU is OK to use before we consider it a storm?

That is a very good question. Normally, when we don't know that answer,
we leave it user-configurable with a sane default :-)

But if we have to be realistic, anything above 20% of CPU time spent in
storm mode for prolonged periods of time would probably mean this system
needs to get scheduled for maintenance anyway.

The whole storm thing is basically showing that a system is about to
fail soon and we're trying to alleviate performance hit from too high
CMCI counts by switching to polling, i.e., prolonged, more graceful hw
fail. :-)

> 2. How do we map that number to polling mode, where we may not see all
> the errors? If we get it wrong, we may end up bouncing at a very high
> rate.

Well, with polling you're bound to miss some errors anyway.

> 3. If we go for a fixed polling rate, how do we make sure it doesn't
> require more CPU than what we determined in (1)?

Yeah, that's the disadvantage of fixed polling rate - we won't know.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
