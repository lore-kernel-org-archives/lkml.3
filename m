Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaHFXh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 19:37:57 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57341 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaHFXh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 19:37:56 -0400
Date: Wed, 6 Aug 2014 16:37:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Triplett <josh@joshtriplett.org>
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Add "make tinyconfig" to configure the tiniest
 possible kernel
In-Reply-To: <20140806224903.GA14782@jtriplet-mobl1>
Message-ID: <alpine.DEB.2.02.1408061637110.13545@chino.kir.corp.google.com>
References: <20140806222419.GA2566@jtriplet-mobl1> <20140806223152.GA14348@jtriplet-mobl1> <alpine.DEB.2.02.1408061537220.13545@chino.kir.corp.google.com> <20140806224903.GA14782@jtriplet-mobl1>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2014, Josh Triplett wrote:

> On Wed, Aug 06, 2014 at 03:38:56PM -0700, David Rientjes wrote:
> > On Wed, 6 Aug 2014, Josh Triplett wrote:
> > > diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> > > index 1568678..2b5ca16 100644
> > > --- a/arch/x86/Makefile
> > > +++ b/arch/x86/Makefile
> > > @@ -257,6 +257,10 @@ PHONY += kvmconfig
> > >  kvmconfig:
> > >  	$(call mergeconfig,kvm_guest)
> > >  
> > > +PHONY += tinyconfig
> > > +tinyconfig: allnoconfig
> > 
> > Calling allnoconfig here makes "make tinyconfig" default to CONFIG_X86_32 
> > even on 64 bit platforms and the caller would need to explicitly do
> > "make ARCH=x86_64 tinyconfig" to avoid it.  It's not clear that this is 
> > intended from the documentation of tinyconfig, that tiniest == 32 bit by 
> > default.
> 
> Calling allnoconfig was quite intentional; this is intended to be the
> smallest possible configuration, and unlike kvmconfig (which modifies an
> existing configuration to make it suitable for a KVM guest), this
> intentionally creates a specific new configuration from scratch.
> 
> 32-bit produces a far smaller kernel than 64-bit, so having that as the
> default for tinyconfig seems quite appropriate.  As you showed, it's
> easy enough to override it if needed.  I'd expect many potential users
> of tinyconfig for embedded systems to start with tinyconfig and then
> immediately use menuconfig to enable a pile of additional options.
> 

In that case, any reason to make tinyconfig x86 only?
