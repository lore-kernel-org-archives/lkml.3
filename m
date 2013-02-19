Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab3BSBMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:12:35 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:51231 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab3BSBMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:12:34 -0500
Message-ID: <1361236341.3263.11.camel@thor.lan>
Subject: Re: [Bisected][-next-20130204+] [x86/kvm] udevd:[97]: segfault at
 ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
From: Peter Hurley <peter@hurleysoftware.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 18 Feb 2013 20:12:21 -0500
In-Reply-To: <20130218225955.GA6166@amt.cnet>
References: <1360715210.31472.20.camel@thor.lan>
	 <511AE0A7.2000101@linux.intel.com> <20130213105129.GB9817@redhat.com>
	 <1360756629.4803.5.camel@thor.lan> <20130218225955.GA6166@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 19:59 -0300, Marcelo Tosatti wrote:
> On Wed, Feb 13, 2013 at 06:57:09AM -0500, Peter Hurley wrote:
> > On Wed, 2013-02-13 at 12:51 +0200, Gleb Natapov wrote:
> > > On Tue, Feb 12, 2013 at 04:39:03PM -0800, H. Peter Anvin wrote:
> > > > On 02/12/2013 04:26 PM, Peter Hurley wrote:
> > > > > With -next-20130204+ in ubuntu 12.10 VM (so the 80x25 VGA
> > > > > device/console):
> > > > > 
> > > > > [    0.666410] udevd[97]: starting version 175
> > > > > [    0.674043] udevd[97]: udevd:[97]: segfault at ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
> > > > > 
> > > > > and boots to an initramfs prompt.
> > > > > 
> > > > > git bisect (log attached) blames:
> > > > > 
> > > > > commit 7b5c4a65cc27f017c170b025f8d6d75dabb11c6f
> > > > > Merge: 3596f5b 949db15
> > > > > Author: H. Peter Anvin <hpa@linux.intel.com>
> > > > > Date:   Fri Jan 25 16:31:21 2013 -0800
> > > > > 
> > > > >     Merge tag 'v3.8-rc5' into x86/mm
> > > > >     
> > > > >     The __pa() fixup series that follows touches KVM code that is not
> > > > >     present in the existing branch based on v3.7-rc5, so merge in the
> > > > >     current upstream from Linus.
> > > > >     
> > > > >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > > > > 
> > > > > 
> > > > > This only happens with the VGA device/console but that is the default
> > > > > configuration for Ubuntu/KVM because it blacklists pretty much every fb
> > > > > driver.
> > > > > 
> > > > 
> > > > I am guessing this is another bad use of __pa()... need to look into that.
> 
> Can't find this commit on kvm.git or linux-2.6.git. Is it reproducible
> there?

This is in the linux-next repo (any git tag after 'next-20130204' will
reproduce this). It's a pretty large merge commit.

This doesn't happen on 3.8-rc7.

I'll try to repro this on kvm.git sometime this week. Otherwise, we can
wait for it to show up in 3.9.

Regards,
Peter Hurley

