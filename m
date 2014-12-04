Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbaLDWIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:08:09 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:48520 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbaLDWIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:08:07 -0500
Date: Thu, 4 Dec 2014 14:06:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RFC] locking: Add volatile to arch_spinlock_t structures
Message-ID: <20141204220657.GB25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141204062005.GA2553@linux.vnet.ibm.com>
 <CA+55aFzn-6asfWHB8SAvz4GJWz7uEriujgVLfaqoo_VPtNBLuA@mail.gmail.com>
 <CA+55aFxGCxQNE4HzRP_Uk2FmFDn_+Hfm6GBz75S+5+SDeODVJQ@mail.gmail.com>
 <20141204070248.GJ25340@linux.vnet.ibm.com>
 <CA+55aFxDmaA2D37Zz1Zc7y6iD6gVs=wskP5wgJb37R98aN-qmg@mail.gmail.com>
 <20141204183628.GT25340@linux.vnet.ibm.com>
 <20141204214546.76b7b7cd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204214546.76b7b7cd@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120422-0017-0000-0000-000006D3B356
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 09:45:46PM +0000, One Thousand Gnomes wrote:
> > anywhere in that translation unit.  After all, any non-static function
> > in that translation unit might be called from some other translation
> > unit that -did- use locking or whatever.
> > 
> > I will let you know how it goes.  ;-)
> 
> It breaks DEC10 ;-)

To say nothing of CDC 6600 systems lacking the compare-move unit.  ;-)

> If there is kickback over things like optimisation perhaps the gcc
> maintainers could at least consider something like
> 
> 	int __attribute((threadsafe)) fred;
> 
> ??

Not needed for recent gcc versions -- both the C11 and C++11 standards
require that different threads be permitted to independently access
different variables, where "different" means "no bits of the two variables
residing in the same byte".  From what I can see, this would mean that
a conforming pre-EV56 Alpha C11 compiler would need to use LDL_L and
STL_C to carry out 8-bit and 16-bit stores.  ;-)

							Thanx, Paul

