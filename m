Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab3CGUYC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:24:02 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:60628 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab3CGUYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:24:00 -0500
Message-ID: <1362687825.31276.5.camel@lambeau>
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Reply-To: mjw@linux.vnet.ibm.com
To: Paul Mackerras <paulus@samba.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mingo@redhat.com, anthony@codemonkey.ws
Date: Thu, 07 Mar 2013 14:23:45 -0600
In-Reply-To: <20130307031124.GB2385@drongo>
References: <20130205214818.4615.12937.stgit@lambeau>
	 <CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
	 <20130219011104.GA5785@amt.cnet> <1362514928.6267.16.camel@lambeau>
	 <20130306014151.GB11481@amt.cnet> <5136FAB4.4020305@parallels.com>
	 <1362587352.6373.6.camel@lambeau> <20130307005216.GA29895@amt.cnet>
	 <20130307031124.GB2385@drongo>
Organization: IBM-LTC
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030720-6102-0000-0000-0000031E6203
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 14:11 +1100, Paul Mackerras wrote:
> On Wed, Mar 06, 2013 at 09:52:16PM -0300, Marcelo Tosatti wrote:
> > On Wed, Mar 06, 2013 at 10:29:12AM -0600, Michael Wolf wrote:
> > > I looked at doing that once but was told that I was changing the
> > > interface in an unacceptable way, because now I was not reporting all of
> > > the elapsed time.  I agree it would make things simpler.
> > 
> > Pointer to that claim, please?
> 
> Back in about 2004 or 2005 or so I was looking at changing how user
> and system times were calculated (in the context of trying to find a
> better way to report resources used by a thread in an SMT processor).
> I found that utilities such as top expected the deltas in the
> /proc/stat numbers to add up to elapsed time, and would report strange
> and inconsistent results if that wasn't the case.  Unfortunately at
> this distance I don't recall the exact details.  I don't know whether
> the expectation that the deltas in the /proc/stat numbers over a
> period of time add up to the elapsed real time is documented anywhere,
> but I wouldn't be at all surprised if some programs depend on it, so
> it's better to maintain that property.

I will have to look at this again.  When looking at the cpu data where
steal time is reported there isn't a problem today.  I will have to run
it and see if there is anything incorrect with the time being reported
for the individual processes.

My real concern here was that in changing the /proc/stat interface am I
going to mess private tools that look at that information.  When I've
looked at vmstat and top they report the cpu information fine, but I may
end up creating problems for home grown scripts and tools.

