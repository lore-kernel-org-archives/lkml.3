Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab3G2XO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 19:14:59 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:48518 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab3G2XO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 19:14:57 -0400
Date: Mon, 29 Jul 2013 17:14:25 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
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
Message-ID: <20130729231425.GA4439@obsidianresearch.com>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F39FD8.6080808@broadcom.com>
 <20130727183059.GD4813@netboy>
 <1441731.8CGUI1tUxh@flatron>
 <20130729180513.GB1884@obsidianresearch.com>
 <20130729222039.GE29970@voom.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729222039.GE29970@voom.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 08:20:39AM +1000, David Gibson wrote:

> > Clearly general purpose systems (eg servers, workstations, etc) with
> > *full featured firmware* fall into category b. Linux already basically
> > has stable DT for those systems - but the firmware is expected to do
> > lots of work and hide all the low level details from the
> > kernel.  Basically, the DT should stick to approximately ePAR and
> > everything else is hidden by the firmware.
> 
> No.  With the exception of the hypervisor/virtualization extensions,
> ePAPR describes (for now) an entirely passive firmware interface.
> That is, once the handover to the OS has happened, there is *no*
> further firmware interaction.  It is not capable of hiding any details
> from the OS, except those which can be done by one-time
> initialization.

Well, one-time initialization details are actually exactly one of the
areas I am thinking about. Some of the embedded SOCs have extensive
one time initization code in the kernel that is highly SOC specific
and on x86 it would live in the firmware.

But I see what you mean, ePAPR was the wrong reference, I didn't
carefully check it. I ment the kind of DT use we've seen in SPARC,
POWER servers, Apple stuff, etc - systems explicitly designed so that
new hardware will boot old OSs.

Jason
