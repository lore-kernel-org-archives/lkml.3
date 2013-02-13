Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab3BMKvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 05:51:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932451Ab3BMKvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 05:51:35 -0500
Date: Wed, 13 Feb 2013 12:51:29 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [Bisected][-next-20130204+] [x86/kvm] udevd:[97]: segfault at
 ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
Message-ID: <20130213105129.GB9817@redhat.com>
References: <1360715210.31472.20.camel@thor.lan>
 <511AE0A7.2000101@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511AE0A7.2000101@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 04:39:03PM -0800, H. Peter Anvin wrote:
> On 02/12/2013 04:26 PM, Peter Hurley wrote:
> > With -next-20130204+ in ubuntu 12.10 VM (so the 80x25 VGA
> > device/console):
> > 
> > [    0.666410] udevd[97]: starting version 175
> > [    0.674043] udevd[97]: udevd:[97]: segfault at ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
> > 
> > and boots to an initramfs prompt.
> > 
> > git bisect (log attached) blames:
> > 
> > commit 7b5c4a65cc27f017c170b025f8d6d75dabb11c6f
> > Merge: 3596f5b 949db15
> > Author: H. Peter Anvin <hpa@linux.intel.com>
> > Date:   Fri Jan 25 16:31:21 2013 -0800
> > 
> >     Merge tag 'v3.8-rc5' into x86/mm
> >     
> >     The __pa() fixup series that follows touches KVM code that is not
> >     present in the existing branch based on v3.7-rc5, so merge in the
> >     current upstream from Linus.
> >     
> >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > 
> > 
> > This only happens with the VGA device/console but that is the default
> > configuration for Ubuntu/KVM because it blacklists pretty much every fb
> > driver.
> > 
> 
> I am guessing this is another bad use of __pa()... need to look into that.
> 
He is using 64bit guest and on those __pa() happens to be working. Is it
possible that slow_virt_to_phys() does not work as expected? Peter (the
bug reporter :)) can you run your guest kernel with loglevel=7 and
attach send me console output?

--
			Gleb.
