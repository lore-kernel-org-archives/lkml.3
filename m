Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab3CFQct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:32:49 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55009 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3CFQcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:32:47 -0500
Message-ID: <1362587352.6373.6.camel@lambeau>
Subject: Re: [PATCH 0/4] Alter steal-time reporting in the guest
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Reply-To: mjw@linux.vnet.ibm.com
To: Glauber Costa <glommer@parallels.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        riel@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        peterz@infradead.org, mingo@redhat.com, anthony@codemonkey.ws
Date: Wed, 06 Mar 2013 10:29:12 -0600
In-Reply-To: <5136FAB4.4020305@parallels.com>
References: <20130205214818.4615.12937.stgit@lambeau>
	 <CAFTL4hyYO7s2u-dRLExA1=TxD00O1XyPe9qFwnODrWi_p92Jqg@mail.gmail.com>
	 <20130219011104.GA5785@amt.cnet> <1362514928.6267.16.camel@lambeau>
	 <20130306014151.GB11481@amt.cnet> <5136FAB4.4020305@parallels.com>
Organization: IBM-LTC
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030616-5518-0000-0000-00000C4330C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 12:13 +0400, Glauber Costa wrote:
> On 03/06/2013 05:41 AM, Marcelo Tosatti wrote:
> > On Tue, Mar 05, 2013 at 02:22:08PM -0600, Michael Wolf wrote:
> >> Sorry for the delay in the response.  I did not see the email
> >> right away.
> >>
> >> On Mon, 2013-02-18 at 22:11 -0300, Marcelo Tosatti wrote:
> >>> On Mon, Feb 18, 2013 at 05:43:47PM +0100, Frederic Weisbecker wrote:
> >>>> 2013/2/5 Michael Wolf <mjw@linux.vnet.ibm.com>:
> >>>>> In the case of where you have a system that is running in a
> >>>>> capped or overcommitted environment the user may see steal time
> >>>>> being reported in accounting tools such as top or vmstat.  This can
> >>>>> cause confusion for the end user.
> >>>>
> >>>> Sorry, I'm no expert in this area. But I don't really understand what
> >>>> is confusing for the end user here.
> >>>
> >>> I suppose that what is wanted is to subtract stolen time due to 'known
> >>> reasons' from steal time reporting. 'Known reasons' being, for example,
> >>> hard caps. So a vcpu executing instructions with no halt, but limited to
> >>> 80% of available bandwidth, would not have 20% of stolen time reported.
> >>
> >> Yes exactly and the end user many times did not set up the guest and is
> >> not aware of the capping.  The end user is only aware of the performance
> >> level that they were told they would get with the guest.  
> >>> But yes, a description of the scenario that is being dealt with, with
> >>> details, is important.
> >>
> >> I will add more detail to the description next time I submit the
> >> patches.  How about something like,"In a cloud environment the user of a
> >> kvm guest is not aware of the underlying hardware or how many other
> >> guests are running on it.  The end user is only aware of a level of
> >> performance that they should see."   or does that just muddy the picture
> >> more??
> > 
> > So the feature aims for is to report stolen time relative to hard
> > capping. That is: stolen time should be counted as time stolen from
> > the guest _beyond_ hard capping. Yes?
> > 
> > Probably don't need to report new data to the guest for that.
> > 
> If we take into account that 1 second always have one second, I believe
> that you can just subtract the consigned time from the steal time the
> host passes to the guest.
> 
> During each second, the numbers won't sum up to 100. The delta to 100 is
> the consigned time, if anyone cares.
> 
> Adopting this would simplify this a lot. All you need to do, really, is
> to get your calculation right from the bandwidth given by the cpu
> controller. Subtract it in the host, and voila.

I looked at doing that once but was told that I was changing the
interface in an unacceptable way, because now I was not reporting all of
the elapsed time.  I agree it would make things simpler.
> 
> 


