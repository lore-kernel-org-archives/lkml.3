Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3LPSnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:43:42 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2845 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3LPSnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:43:40 -0500
Date: Mon, 16 Dec 2013 11:43:33 -0700
From: jerry.hoemann@hp.com
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Message-ID: <20131216184333.GA25634@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
 <20131121233104.GF1106@anatevka.fc.hp.com>
 <20131121233831.GB32121@srcf.ucam.org>
 <20131122010515.GG1106@anatevka.fc.hp.com>
 <20131122011613.GA1039@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122011613.GA1039@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 01:16:13AM +0000, Matthew Garrett wrote:
> On Thu, Nov 21, 2013 at 06:05:15PM -0700, jerry.hoemann@hp.com wrote:
> > On Thu, Nov 21, 2013 at 11:38:31PM +0000, Matthew Garrett wrote:
> > > Hm. If the problem is fragmentation, then yeah, I can imagine this 
> > > causing problems. In that case we could take a two-pass approach - find 
> > > a gap that *will* be big enough, reserve everything that isn't currently 
> > > reserved, and then reserve the rest after ExitBootServices()?
> > 
> > 
> 
> > Interesting questions, but as I don't have access to a system that has
> > the firmware defects encountered when efi_reserve_boot_services, it makes
> > it difficult to test that i don't break them.  Hence, the appealing nature
> > of quirks.  Don't have to worry about breaking other platforms as they
> > continue to operate same as before.
> 
> Yeah. The problem is that some users may want kdump while still having 
> broken firmware, so a solution that works for them is much more 
> appealing than one which involves manually maintaining a list of 
> verified systems...

Matthew, 

Sorry for the delay in replying.

We've worked with our firmware engineers who have made changes
to move around where certain drivers are allocating from which
has helped reduce some of the fragmentation issue we were having.
Since we are taking firmware drops from outside sources, we are
subject to regressions in this area, so i'm still interested in
this topic.

To your point, kdump may still works for the platforms that
have the broken firmware.  Much depends upon the memory and IO
configuration on the system in question.

>From prior mailing, apparently Macs are subject to the problem
that efi_reserve_boot_services was created to address.  Smaller
systems w/ less IO don't require the larger crash kernel allocations
and hence are more likely to be able to find a gap in low memory
that works.

Its the larger systems with lots of cpus, memory, and IO that
need to allocate the large crash kernels.  These types of systems
are more at risk.

Again,  my main concern is finding something that can be back ported
into legacy kernels/distros.  For distros based upon newer kernel and
associated tools, we can avoid the problem by allocating memory high.
But, we don't have that option with legacy kernels/distros.

So, if you have other suggestions, I'm willing to explore them.


Jerry

-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

