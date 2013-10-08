Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3JHWI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 18:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab3JHWI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 18:08:26 -0400
Date: Tue, 8 Oct 2013 19:08:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] pvclock: detect watchdog reset at pvclock read
Message-ID: <20131008220811.GC16625@amt.cnet>
References: <20131008010515.516032211@amt.cnet>
 <20131008010552.779616517@amt.cnet>
 <20131008133705.GR227855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008133705.GR227855@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:37:05AM -0400, Don Zickus wrote:
> On Mon, Oct 07, 2013 at 10:05:17PM -0300, Marcelo Tosatti wrote:
> > Implement reset of kernel watchdogs at pvclock read time. This avoids
> > adding special code to every watchdog.
> > 
> > This is possible for watchdogs which measure time based on sched_clock() or 
> > ktime_get() variants.
> > 
> > Suggested by Don Zickus.
> > 
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> Awesome.  Thanks for figuring this out Marcelo.  Does that mean we can
> revert commit 5d1c0f4a now? :-)

Unfortunately no: soft lockup watchdog does not measure time based on
sched_clock but on hrtimer interrupt count :-(
(see the the softlockup code in question, perhaps you can point to 
something that i'm missing).

BTW, are you OK with printing additional steal time information?
https://lkml.org/lkml/2013/6/27/755

> This meets my expectations.  I'll leave it to the virt folks to figure out
> if this covers all the corner cases or not.
> 
> Cheers,
> Don

Thanks

