Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaEUSSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:18:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaEUSSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:18:02 -0400
Date: Wed, 21 May 2014 20:17:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, thomas.mingarelli@hp.com
Subject: Re: [PATCH 5/6] x86, nmi: Move default external NMI handler to its
 own routine
Message-ID: <20140521181756.GJ2485@laptop.programming.kicks-ass.net>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
 <1400181949-157170-6-git-send-email-dzickus@redhat.com>
 <20140521103846.GA2485@laptop.programming.kicks-ass.net>
 <20140521164848.GZ50500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521164848.GZ50500@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 12:48:48PM -0400, Don Zickus wrote:
> On Wed, May 21, 2014 at 12:38:46PM +0200, Peter Zijlstra wrote:
> > On Thu, May 15, 2014 at 03:25:48PM -0400, Don Zickus wrote:
> > > Now that we have setup an NMI subtye called NMI_EXT, there is really
> > > no need to hard code the default external NMI handler in the main
> > > nmi handler routine.
> > > 
> > > Move it to a proper function and register it on boot.  This change is
> > > just code movement.
> > > 
> > > In addition, update the hpwdt to allow it to unregister the default
> > > handler on its registration (and vice versa).  This allows the driver
> > > to take control of that io port (which it ultimately wanted to do
> > > originally), but in a cleaner way.
> > 
> > wanting that is one thing, but is it also a sane thing? You don't do
> > thing just because drivers want it.
> 
> Heh. I understand.
> 
> Today, I have hacked up the SERR and IOCHK handlers to give hpwdt the
> chance to do its 'magic' bios call to collect information before
> panic'ing.
> 
> I was trying to clean things up by removing those hacks, but I guess I can
> see your point, there is no guarantee they handle the hardware correctly.
> :-/

So while I'll leave the decision to the x86 people, I find the changelog
entirely devoid of a good reason to do this.

An in my personal opinion any hardware that triggers non detectable NMIs
is just plain broken.
