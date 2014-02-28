Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaB1Ha3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:30:29 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64445 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaB1Ha1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:30:27 -0500
Date: Fri, 28 Feb 2014 14:30:15 +0700
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: Dave Jones <davej@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Message-ID: <20140228073011.GA26449@debian.local>
References: <20140225060146.GA4339@debian.local>
 <530C7465.2080600@zytor.com>
 <20140225162611.GA31902@redhat.com>
 <530CCFD2.3050007@zytor.com>
 <20140226121256.GA8494@debian.local>
 <20140226131852.GA22690@pd.tnic>
 <20140226154949.GA770@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226154949.GA770@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:49:49AM -0500, Dave Jones wrote:
> On Wed, Feb 26, 2014 at 02:18:52PM +0100, Borislav Petkov wrote:
>  > On Wed, Feb 26, 2014 at 07:12:59PM +0700, Chris Bainbridge wrote:
>  > > @@ -226,6 +234,15 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
>  > >  		clear_cpu_cap(c, X86_FEATURE_SEP);
>  > >  
>  > >  	/*
>  > > +	 * PAE CPUID bug: Pentium M reports no PAE but has PAE
>  > > +	 */
>  > > +	if (forcepae) {
>  > > +		printk(KERN_WARNING "PAE forced!\n");
>  > > +		set_cpu_cap(c, X86_FEATURE_PAE);
>  > > +		add_taint(TAINT_MACHINE_CHECK, LOCKDEP_NOW_UNRELIABLE);
>  > 
>  > This is certainly the wrong taint flag. We'd need a new one or to
>  > repurpose another one as I suggested in a previous mail.
> 
> I'd suggest repurposing 'S'. Instead of 'unsafe smp', it could mean
> "out of Spec". We currently only use that flag on some ancient athlon xp,
> so there's not going to be any kind of collision.
> 
> Start with the below maybe ?
> 
> 	Dave

Patch looks fine. Is the patch I previously posted, combined with this
patch, sufficient for inclusion in the kernel? Or is there anything else
I need to do?
