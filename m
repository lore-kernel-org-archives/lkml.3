Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab3GMTdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 15:33:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:11733 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab3GMTds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 15:33:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,660,1367996400"; 
   d="scan'208";a="267931681"
Message-ID: <1373744026.3475.122.camel@envy.home>
Subject: Re: [PATCH 3/3] pch_gbe: Add MinnowBoard support
From: Darren Hart <dvhart@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org
Date: Sat, 13 Jul 2013 12:33:46 -0700
In-Reply-To: <20130713170914.GA3837@kroah.com>
References: <ce5dd365d05f8747d269aa74e0bb929935d9cdee.1373676797.git.dvhart@linux.intel.com>
	 <ad20133699c36bd8d183dd685f1b35f6d6b99005.1373676797.git.dvhart@linux.intel.com>
	 <20130713011731.GA17939@kroah.com> <1373694381.3475.95.camel@envy.home>
	 <20130713062631.GB15155@kroah.com> <1373731681.3475.113.camel@envy.home>
	 <20130713170914.GA3837@kroah.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-13 at 10:09 -0700, Greg KH wrote:
> On Sat, Jul 13, 2013 at 09:08:01AM -0700, Darren Hart wrote:

...
> > I was looking at it as a quirk:
> > 
> > " - New device IDs and quirks are also accepted."
> > 
> > I even considered implementation as a pci quirk. I didn't because the
> > PHY work needed to happen too late during probe. The frustrating thing
> > is there is probably 15 lines of code that are needed to get it to
> > work, all the rest is infrastructure to make it generic.
> 
> 163 lines of code is not a "quirk" I can accept.  When I wrote, "new
> device ids or quirks can be accpted for stable", I meant things like
> commit 9e9dd0e889c76c786e8f2e164c825c3c06dea30c.  That's acceptable.
> Not thing huge thing.

Got it. I was confused on "new device IDs and quirks" versus "support
for new hardware". My fault, that's clear now. 

...
> > I get the size argument. It's too big. The docs say 100 lines with
> > context, I've seen much larger go in... I just wasn't sure where the
> > line is. It seems things are getting more strict here, not less. OK.
> > Lesson learned.
> 
> You have seen larger "quirks" than this go into the stable tree?
> Examples for where I've been sleeping on the job would be good.

No, sorry, I just meant patches larger than 100 lines with context,
that's all.

...
> > > This isn't going to land in Linus's tree until 3.12 anyway, so what's
> > > the rush?
> > 
> > My reasoning is that the BSP for this is based on 3.8. I would like to
> > bring 3.8 in sync with master for support of this board so I can update
> > the release BSP to use the same sources. People can use my code from
> > the linux-yocto_3.8 standard/minnow branch, but it would be preferable
> > if that code was also destined for upstream.
> 
> That's your choice to pick 3.8, not upstream's (and frankly, not
> something that I would have picked, but that's another topic...)

Maybe we can catch up at LPC or something, I'd like to hear your
thoughts on that. Of course there are a lot of factors that go into
that decision, and the bulk of it is consolidating effort on a single
tree across BSPs in a project that has a 6 month release cadence.

...
> You are adding functionality for new devices that take much more than a
> simple "add an id to a table", so no, it's not ok for stable releases.

Got it, I'll drop the stable lines from the subsequent versions and
keep that in mind for future projects. I'm trying to think if I can
polish up the docs to help clarify things, thinking on it.

Thank you Greg.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

