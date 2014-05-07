Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaEGVNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:13:50 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:41592 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaEGVNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:13:48 -0400
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 7 May 2014 17:17:22 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
In-Reply-To: <20140507182410.GA8607@moon>
Message-ID: <alpine.DEB.2.10.1405071713590.7020@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu> <20140506202307.GA1458@moon> <alpine.DEB.2.10.1405061729350.4849@vincent-weaver-1.umelst.maine.edu> <20140506214630.GB1458@moon> <alpine.DEB.2.10.1405071244570.6340@vincent-weaver-1.umelst.maine.edu>
 <20140507164902.GD1444@moon> <20140507165811.GG1444@moon> <alpine.DEB.2.10.1405071305010.6340@vincent-weaver-1.umelst.maine.edu> <20140507182410.GA8607@moon>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Cyrill Gorcunov wrote:

> > I thought I was running with PeterZ's latest patch that was supposed to 
> > avoid the corruption.  Hmmm.  Let me reboot and try a few more things.
> 
> Thanks! Please ping me if find something new.

It turns out to be my fault, I was running with an incomplete version of 
PeterZ's patch.  We need to get the fix into the kernel as apparently I 
fail at manually applying patches across multiple machines.

So to summarize, with PeterZ's fix the various memory corruption crashes 
in the p4 code no longer happen.

When fuzzing on the p4 *other* things do happen.
	* at least two warnings pop up almost instantly
	* eventually the machine will crash in an endless NMI storm
	* also I managed to get the machine wedged with an unkillable
	  process, sort of like the known problem PeterZ has.

The NMI issue is probably the only one that is p4 related, and I do get 
the NMI warnings on other machines too, it's just the p4 is the only one 
where it brings down the machine.

Vince
