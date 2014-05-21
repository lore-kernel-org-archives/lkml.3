Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaEUQt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaEUQt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:49:26 -0400
Date: Wed, 21 May 2014 12:48:48 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, thomas.mingarelli@hp.com
Subject: Re: [PATCH 5/6] x86, nmi: Move default external NMI handler to its
 own routine
Message-ID: <20140521164848.GZ50500@redhat.com>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
 <1400181949-157170-6-git-send-email-dzickus@redhat.com>
 <20140521103846.GA2485@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521103846.GA2485@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 12:38:46PM +0200, Peter Zijlstra wrote:
> On Thu, May 15, 2014 at 03:25:48PM -0400, Don Zickus wrote:
> > Now that we have setup an NMI subtye called NMI_EXT, there is really
> > no need to hard code the default external NMI handler in the main
> > nmi handler routine.
> > 
> > Move it to a proper function and register it on boot.  This change is
> > just code movement.
> > 
> > In addition, update the hpwdt to allow it to unregister the default
> > handler on its registration (and vice versa).  This allows the driver
> > to take control of that io port (which it ultimately wanted to do
> > originally), but in a cleaner way.
> 
> wanting that is one thing, but is it also a sane thing? You don't do
> thing just because drivers want it.

Heh. I understand.

Today, I have hacked up the SERR and IOCHK handlers to give hpwdt the
chance to do its 'magic' bios call to collect information before
panic'ing.

I was trying to clean things up by removing those hacks, but I guess I can
see your point, there is no guarantee they handle the hardware correctly.
:-/

Cheers,
Don

