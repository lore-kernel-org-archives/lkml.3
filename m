Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaJPRql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:46:41 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11386 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752197AbaJPRqj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:46:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 77.231.154.87
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+S7jC5ktvziI7SDGPl1VM7
Date: Thu, 16 Oct 2014 19:46:28 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Carles =?iso-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
Message-ID: <20141016174628.GL1972@vicerveza.homeunix.net>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
 <20141015215701.GA4109@f1.synalogic.ca>
 <1413413127.17186.5.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141016173401.GA16515@f1.synalogic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20141016173401.GA16515@f1.synalogic.ca>
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:34:01AM -0700, Benjamin Poirier wrote:
> On 2014/10/15 15:45, Eric Dumazet wrote:
> > On Wed, 2014-10-15 at 14:57 -0700, Benjamin Poirier wrote:
> > > On 2014/10/13 12:52, Lluís Batlle i Rossell wrote:
> > > > Hello,
> > > > 
> > > > on the 7th of January 2014 ths patch was applied:
> > > > https://lkml.org/lkml/2014/1/7/307
> > > > 
> > > > [PATCH v2] net: Do not enable tx-nocache-copy by default
> > > >         
> > > > In the Sheevaplug (ARM Feroceon 88FR131 from Marvell) this made packets to be
> > > > sent corrupted. I think this machine has something special about the cache.
> > > > 
> > > > Enabling back this tx-nocache-copy (as it used to be before the patch) the
> > > > transfers work fine again. I think that most people, encountering this problem,
> > > > completely disable the tx offload instead of enabling back this setting.
> > > > 
> > > > Is this an ARM kernel problem regarding this platform?
> > > 
> > > This is odd, only x86 defines ARCH_HAS_NOCACHE_UACCESS. On arm,
> > > skb_do_copy_data_nocache() should end up using __copy_from_user()
> > > regardless of tx-nocache-copy.
> > 
> >  kmap_atomic()/kunmap_atomic() is missing, so we lack
> > __cpuc_flush_dcache_area() operations.
> > 
> 
> You lost me there.
> 1) I don't see the link
> 2) It seems kmap_atomic and so on are there:
> $ grep kmap_atomic System.map-3.16-2-kirkwood
> c0014838 T kmap_atomic
> c001491c T kmap_atomic_pfn
> c00149a4 T kmap_atomic_to_page
> 
> MACH_KIRKWOOD selects CPU_FEROCEON which has
> __cpuc_flush_dcache_area ->
> 	cpu_cache.flush_kern_dcache_area ->
> 		feroceon_flush_kern_dcache_area

Hello all,

it seems I was a bit wrong - although enabling back tx-nocache-copy makes the
tx-errors happen much less often (ssh complaining about HMAC), they still
happen. It seems that something was introduced in some recent kernels that broke
the tx offload.

I have no idea what it can be, but since 2.6 until at least 3.10 the network
driver worked fine with tx offload in this sheevaplug board.

Regards,
Lluís.
