Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3A3I30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 03:29:26 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:60603 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752506Ab3A3I3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 03:29:25 -0500
Message-ID: <1359534563.32305.6.camel@joe-AO722>
Subject: Re: coccinelle and bitmask arithmetic
From: Joe Perches <joe@perches.com>
To: wharms@bfs.de
Cc: Julia Lawall <julia.lawall@lip6.fr>, Russell King <linux@arm.linux.org.uk>,
        Mike Rapoport <mike@compulab.co.il>, Valdis.Kletnieks@vt.edu,
        cocci@systeme.lip6.fr, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Fulghum <paulkf@microgate.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Wed, 30 Jan 2013 00:29:23 -0800
In-Reply-To: <5108D808.6010405@bfs.de>
References: <20130127194039.GA18787@elgon.mountain>
	 <1359317078.14406.12.camel@joe-AO722> <20130127201947.GO16282@mwanda>
	 <9561.1359474916@turing-police.cc.vt.edu>
	 <1359475998.4196.26.camel@joe-AO722>
	 <alpine.DEB.2.02.1301291847070.3339@hadrien>
	 <1359482637.15135.7.camel@joe-AO722> <5108D808.6010405@bfs.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-30 at 09:21 +0100, walter harms wrote:
> Am 29.01.2013 19:03, schrieb Joe Perches:
> > On Tue, 2013-01-29 at 18:49 +0100, Julia Lawall wrote:
> >> How about the following (from today's linux-next).  They appear to be
> >> trying to do the same calculation, once with + and once with |.
> > 
> > (cc'ing the original developer and Russell King)
> > 
> > Likely the it8152_pci_platform_notify uses should use +
> > 
> >> arch/arm/common/it8152.c
> >>
> >> int dma_set_coherent_mask(struct device *dev, u64 mask)
> >> {
> >>         if (mask >= PHYS_OFFSET + SZ_64M - 1)
> >>                 return 0;
> >>
> >>         return -EIO;
> >> }
> >>
> 
> Great hit Joe :)

Julia and the others in the coccinelle group are the ones
with the whizzy program.


