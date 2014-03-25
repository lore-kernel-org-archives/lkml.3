Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbaCYSCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:02:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151AbaCYSB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:01:56 -0400
Date: Tue, 25 Mar 2014 11:01:50 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Christoph Lameter <cl@linux.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: slub: gpf in deactivate_slab
Message-ID: <20140325180149.GD7519@dhcp22.suse.cz>
References: <53208A87.2040907@oracle.com>
 <5331A6C3.2000303@oracle.com>
 <20140325165247.GA7519@dhcp22.suse.cz>
 <alpine.DEB.2.10.1403251205140.24534@nuc>
 <20140325175634.GC7519@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140325175634.GC7519@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 25-03-14 10:56:34, Michal Hocko wrote:
> On Tue 25-03-14 12:06:36, Christoph Lameter wrote:
> > On Tue, 25 Mar 2014, Michal Hocko wrote:
> > 
> > > You are right. The function even does VM_BUG_ON(!irqs_disabled())...
> > > Unfortunatelly we do not seem to have an _irq alternative of the bit
> > > spinlock.
> > > Not sure what to do about it. Christoph?
> > >
> > > Btw. it seems to go way back to 3.1 (1d07171c5e58e).
> > 
> > Well there is a preempt_enable() (bit_spin_lock) and a preempt_disable()
> > bit_spin_unlock() within a piece of code where irqs are disabled.
> > 
> > Is that a problem? Has been there for a long time.
> 
> It is because preempt_enable calls __preempt_schedule when the preempt
> count drops down to 0. You would need to call preempt_disable before you
> disable interrupts or use an irq safe bit spin unlock which doesn't
> enabled preemption unconditionally.

Hmm, now that I am looking into the code more closely it seems that
preempt_schedule bails out when interrupts are disabled.
-- 
Michal Hocko
SUSE Labs
