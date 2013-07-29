Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab3G2SFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:05:25 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:48569 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab3G2SFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:05:22 -0400
Date: Mon, 29 Jul 2013 12:05:13 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Arend van Spriel <arend@broadcom.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130729180513.GB1884@obsidianresearch.com>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F39FD8.6080808@broadcom.com>
 <20130727183059.GD4813@netboy>
 <1441731.8CGUI1tUxh@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1441731.8CGUI1tUxh@flatron>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 11:51:06AM -0700, Tomasz Figa wrote:

> Well, it depends on how we use the DT. There are (at least) two possible 
> usage scenarios:
> 
>  a) using DT as direct replacement for board files - this means that you 
>     are free to say that DTSes are strictly coupled with kernel version 
>     and you are free to modify the bindings - see the analogy to board 
>     files, where you could modify the platform data structures and could 
>     not directly copy board file from one kernel version to another,
> 
>  b) using DT as an ABI - this is the original way, i.e. define stable 
>     bindings and make sure that anu DTB built for older kernel will work,
>     with equal or greater set of functionality on newer kernels.
> 
> Now I believe in this thread the point whether we should use a) or b) or a 
> combination of both has been raised.

Right, and I think it is very important to consider that different
systems can legitimately fall into those categories.

Clearly general purpose systems (eg servers, workstations, etc) with
*full featured firmware* fall into category b. Linux already basically
has stable DT for those systems - but the firmware is expected to do
lots of work and hide all the low level details from the
kernel. Basically, the DT should stick to approximately ePAR and
everything else is hidden by the firmware. This is essentially how x86
works and achieves its compatibility.

Systems that have minimalist firmware, where firmware functions are
pushed into the kernel and the DT is now required to describe
intricate and unique SOC specific functions are clearly very
different, and I think it makes sense to encourage those environments
to be case 'a'.

Basically, minimalist firmware should have a boot process design that
*can* couple the DT and kernel, while full featured firmware should
keep them seperate. IMHO that should be the clear message to people
implementing this stuff.

After enough time the DT for 'a' should become stable and churn free,
but expecting/demanding that from day 0 is not helping anyone, IMHO.

Jason
