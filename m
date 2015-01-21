Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbbAUKxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:53:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbbAUKxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:53:03 -0500
Date: Wed, 21 Jan 2015 11:52:51 +0100
From: Andrew Jones <drjones@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: uobergfe@redhat.com, dzickus@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: Confusing behaviour with /proc/sys/kernel/nmi_watchdog
Message-ID: <20150121105251.GA3040@hawk.usersys.redhat.com>
References: <20141105093420.1c7500d8@kryten>
 <20141105102645.GA3046@hawk.usersys.redhat.com>
 <20150121143942.1549e9c9@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121143942.1549e9c9@kryten>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 02:39:42PM +1100, Anton Blanchard wrote:
> Hi Andrew,
> 
> > On Wed, Nov 05, 2014 at 09:34:20AM +1100, Anton Blanchard wrote:
> > > commit 9919e39a1738 ("kvm: ensure hard lockup detection is disabled
> > > by default") provided a way for the kernel to disable the hard
> > > lockup detector at runtime.
> > > 
> > > I'm using it on ppc64 but notice some weird behaviour with the
> > > nmi_watchdog procfs variable. At boot, that the hard lockup
> > > detector appears to be enabled even when we disable it via
> > > watchdog_enable_hardlockup_detector(false):
> > > 
> > > # cat /proc/sys/kernel/nmi_watchdog 
> > > 1
> > > 
> > > I have to echo 0 to it then echo 1 again to enable it.
> > > 
> > > Anton
> > 
> > Hi Anton,
> > 
> > Yes, the nmi watchdog proc variables are currently a bit
> > confusing. Uli has posted a series to clear all that up
> > though. Please see
> > 
> > https://lkml.org/lkml/2014/10/17/340
> 
> Any progress on this? I'm rebasing our hardware NMI patch for ppc64 and
> notice the strange behaviour is still in mainline.
> 

Hi Anton,

I'm not aware of anything blocking this series, but maybe I missed
something. Andrew Morton and Don Zickus are the ones to ask. Andrew?
Don?

Thanks,
drew
