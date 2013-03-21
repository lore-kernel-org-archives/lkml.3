Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3CUAJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:09:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab3CUAJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:09:10 -0400
Date: Wed, 20 Mar 2013 20:08:45 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: mingo@redhat.com, konrad.wilk@oracle.com, tglx@linutronix.de,
        rostedt@goodmis.org, kraman@redhat.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, bp@alien8.de, samu.kallio@aberdeencloud.com,
        xen-devel@lists.xen.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when
 running on bare metal
Message-ID: <20130321000845.GC15821@hansolo.jdub.homelinux.org>
References: <5afe14ac-bc17-4fd1-9680-8f2566322437@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5afe14ac-bc17-4fd1-9680-8f2566322437@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 06:53:55AM -0700, Boris Ostrovsky wrote:
> 
> ----- jwboyer@redhat.com wrote:
> 
> > On Wed, Mar 13, 2013 at 09:25:44AM -0400, Boris Ostrovsky wrote:
> > > On 03/01/2013 07:14 AM, Josh Boyer wrote:
> > > >On Thu, Feb 28, 2013 at 04:52:20PM -0800, H. Peter Anvin wrote:
> > > >>On 02/28/2013 04:42 PM, Josh Boyer wrote:
> > > >>>On Fri, Mar 01, 2013 at 01:36:29AM +0100, Borislav Petkov wrote:
> > > >>>>On Thu, Feb 28, 2013 at 04:15:45PM -0800, H. Peter Anvin wrote:
> > > >>>>>>I'll try to get someone to test this tomorrow.
> > > >>>>Btw, you'd need to apply that other patch too
> > > >>>>
> > > >>>>http://marc.info/?l=xen-devel&m=136206183814547&w=2
> > > >>>>
> > > >>>>so that arch_flush_lazy_mmu_mode() has at least one caller on
> > x86_64.
> > > >>>Yeah, we already have that applied.  It stops crashes in xen
> > > >>>environments so we pulled it in as a bugfix.  Thanks though!
> > > >>>
> > > >>Who are "we"?
> > > >Sorry, Fedora.  That patch has a link to a bug in it.  We applied
> > the
> > > >patch for that bug.  I'll apply Boris' patch on top and get the
> > same
> > > >people to test it.
> > > 
> > > Josh, have you had a chance to test this?
> > 
> > I've tested it on bare metal for a while now.  No problems noticed at
> > all.  I've not heard back from Krishna who was testing it in the Xen
> > environment.  Krishna?
> 
> 
> Any updates?

No.  I've still not heard from Krishna.

At this point I've tested it on bare metal quite a bit, and Konrad has
tested it on both bare metal and Xen.  That should already cover the
case Krishna was going to test anyway.  I suggest we move forward and
take the patch.

josh
