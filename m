Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab3BSI1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:27:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab3BSI1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:27:01 -0500
Date: Tue, 19 Feb 2013 10:26:56 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [Bisected][-next-20130204+] [x86/kvm] udevd:[97]: segfault at
 ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
Message-ID: <20130219082656.GE3600@redhat.com>
References: <1360715210.31472.20.camel@thor.lan>
 <511AE0A7.2000101@linux.intel.com>
 <20130213105129.GB9817@redhat.com>
 <1360756629.4803.5.camel@thor.lan>
 <20130218225955.GA6166@amt.cnet>
 <1361236341.3263.11.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361236341.3263.11.camel@thor.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 08:12:21PM -0500, Peter Hurley wrote:
> On Mon, 2013-02-18 at 19:59 -0300, Marcelo Tosatti wrote:
> > On Wed, Feb 13, 2013 at 06:57:09AM -0500, Peter Hurley wrote:
> > > On Wed, 2013-02-13 at 12:51 +0200, Gleb Natapov wrote:
> > > > On Tue, Feb 12, 2013 at 04:39:03PM -0800, H. Peter Anvin wrote:
> > > > > On 02/12/2013 04:26 PM, Peter Hurley wrote:
> > > > > > With -next-20130204+ in ubuntu 12.10 VM (so the 80x25 VGA
> > > > > > device/console):
> > > > > > 
> > > > > > [    0.666410] udevd[97]: starting version 175
> > > > > > [    0.674043] udevd[97]: udevd:[97]: segfault at ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
> > > > > > 
> > > > > > and boots to an initramfs prompt.
> > > > > > 
> > > > > > git bisect (log attached) blames:
> > > > > > 
> > > > > > commit 7b5c4a65cc27f017c170b025f8d6d75dabb11c6f
> > > > > > Merge: 3596f5b 949db15
> > > > > > Author: H. Peter Anvin <hpa@linux.intel.com>
> > > > > > Date:   Fri Jan 25 16:31:21 2013 -0800
> > > > > > 
> > > > > >     Merge tag 'v3.8-rc5' into x86/mm
> > > > > >     
> > > > > >     The __pa() fixup series that follows touches KVM code that is not
> > > > > >     present in the existing branch based on v3.7-rc5, so merge in the
> > > > > >     current upstream from Linus.
> > > > > >     
> > > > > >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > > > > > 
> > > > > > 
> > > > > > This only happens with the VGA device/console but that is the default
> > > > > > configuration for Ubuntu/KVM because it blacklists pretty much every fb
> > > > > > driver.
> > > > > > 
> > > > > 
> > > > > I am guessing this is another bad use of __pa()... need to look into that.
> > 
> > Can't find this commit on kvm.git or linux-2.6.git. Is it reproducible
> > there?
> 
> This is in the linux-next repo (any git tag after 'next-20130204' will
> reproduce this). It's a pretty large merge commit.
> 
> This doesn't happen on 3.8-rc7.
> 
> I'll try to repro this on kvm.git sometime this week. Otherwise, we can
> wait for it to show up in 3.9.
> 
Can you also drop 5dfd486c4750c9278c63fa96e6e85bdd2fb58e9d from linux-next and reproduce?

--
			Gleb.
