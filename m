Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3A2XjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:39:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57865 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab3A2Xiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:38:51 -0500
Date: Tue, 29 Jan 2013 17:38:42 -0600
From: Nishanth Menon <nm@ti.com>
To: Ruslan Bilovol <ruslan.bilovol@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <eduardo.valentin@ti.com>
Subject: Re: [RFC PATCH 0/2] ARM: update cpuinfo to print CPU model name
Message-ID: <20130129233842.GA8024@kahuna>
References: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
 <20130129160243.GA3389@kahuna>
 <CAB=otbSV6CH4WOrr577bHXFcjEVRGjZxatgy4CJ3cr0M0h4vfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAB=otbSV6CH4WOrr577bHXFcjEVRGjZxatgy4CJ3cr0M0h4vfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01:08-20130130, Ruslan Bilovol wrote:
> Hi,
> 
> On Tue, Jan 29, 2013 at 6:02 PM, Nishanth Menon <nm@ti.com> wrote:
> >
> > On 17:54-20130129, Ruslan Bilovol wrote:
> > > Hi,
> > >
> > > The following patches update cpuinfo to print CPU
> > > model name for ARM. First patch exactly makes needed
> > > changes for ARM architecture.
> > > Second patch adds this ability to OMAP4 SoCs.
> > >
> > > This adds a common approach to show SoC name.
> > >
> > > Looks like there were few attempts to do similar
> > > changes to cpuinfo without any luck.
> > >
> > > So - comments are welcome
> > >
> > > Ruslan Bilovol (2):
> > >   ARM: kernel: update cpuinfo to print CPU model name
> > >   ARM: OMAP4: setup CPU model name during ID initialisation
> >
> > We had an discussion on similar lines but a generic suggestion:
> > https://patchwork.kernel.org/patch/98720/
> > SoCinfo framework which was supposed to introduce this
> >
> > Would'nt that be a better approach to take than an OMAP only solution?
> 
> My goal is only to say what is the SoC model name in the /proc/cpuinfo
> (And it is not an OMAP-only solution - it is common. Support for OMAP
> is added in second patch)
> This is the only type of information that we can apply for any SoC.
> My point is - any SoC-specific information should go through some other
> way - like SoCinfo framework mentioned by you.
> And additional point - in cpuinfo we already have CPU name and Machine name.
> The SoC name (that is something between these two things) looks also relevant
Looking at the sample output in patch #1/2
OMAP4470 ES1.0 HS

OMAP4470 is SoC name
ES1.0 is SoC revision
HS is SoC type

We even have SoC features (e.g. at boot NEON etc..)

Is the intent to put all this inside /proc/cpuinfo?? I bet every SoC has
it's own interesting data it'd like to have (like some of the info
populated by DT even). I am hardpressed to think this fits inside
/proc/cpuinfo. I might even suspect that the list of interesting
information might even vary per SoC.

having machine name is something ARM specific? dumping it on my linux
machines (x86[1] and sparc[2]) dont seem to show that.

but in the interest of not breaking existing interfaces, new interfaces
should potentially belong elsewhere.. my 2 cents.

[1] http://pastebin.com/CF8HPDAC (Xubuntu 12.04 3.2.0-36)
[2] http://pastebin.com/qNwWHwiu (Debian 3.2.35-2)
-- 
Regards,
Nishanth Menon
