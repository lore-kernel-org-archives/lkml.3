Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaJOWpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 18:45:30 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50238 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaJOWp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 18:45:29 -0400
Message-ID: <1413413127.17186.5.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Regarding tx-nocache-copy in the Sheevaplug
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: =?ISO-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Carles =?ISO-8859-1?Q?Pag=E8s?= <page@cubata.homelinux.net>,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 15 Oct 2014 15:45:27 -0700
In-Reply-To: <20141015215701.GA4109@f1.synalogic.ca>
References: <20141013105246.GD1972@vicerveza.homeunix.net>
	 <20141015215701.GA4109@f1.synalogic.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 14:57 -0700, Benjamin Poirier wrote:
> On 2014/10/13 12:52, Lluís Batlle i Rossell wrote:
> > Hello,
> > 
> > on the 7th of January 2014 ths patch was applied:
> > https://lkml.org/lkml/2014/1/7/307
> > 
> > [PATCH v2] net: Do not enable tx-nocache-copy by default
> >         
> > In the Sheevaplug (ARM Feroceon 88FR131 from Marvell) this made packets to be
> > sent corrupted. I think this machine has something special about the cache.
> > 
> > Enabling back this tx-nocache-copy (as it used to be before the patch) the
> > transfers work fine again. I think that most people, encountering this problem,
> > completely disable the tx offload instead of enabling back this setting.
> > 
> > Is this an ARM kernel problem regarding this platform?
> 
> This is odd, only x86 defines ARCH_HAS_NOCACHE_UACCESS. On arm,
> skb_do_copy_data_nocache() should end up using __copy_from_user()
> regardless of tx-nocache-copy.

 kmap_atomic()/kunmap_atomic() is missing, so we lack
__cpuc_flush_dcache_area() operations.





