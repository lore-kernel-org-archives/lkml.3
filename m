Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab3HNQlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:41:52 -0400
Received: from smtp.citrix.com ([66.165.176.89]:38625 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445Ab3HNQlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:41:51 -0400
X-IronPort-AV: E=Sophos;i="4.89,878,1367971200"; 
   d="scan'208";a="44247056"
Date: Wed, 14 Aug 2013 17:41:49 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <Ian.Campbell@citrix.com>
Subject: Re: [PATCH v3 07/10] xen: introduce XENMEM_get_dma_buf and
 xen_put_dma_buf
In-Reply-To: <20130809155050.GA8462@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1308141740400.4470@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308051503190.4893@kaball.uk.xensource.com> <1375720256-8014-7-git-send-email-stefano.stabellini@eu.citrix.com> <20130809153606.GD5637@phenom.dumpdata.com> <20130809155050.GA8462@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013, Konrad Rzeszutek Wilk wrote:
> > > +struct xen_get_dma_buf {
> > > +    /*
> > > +     * [IN] Details of memory extents to be exchanged (GMFN bases).
> > > +     * Note that @in.address_bits is ignored and unused.
> > 
> > Ohhhh, why? What if the user wants to be it under 2G?
> 
> Looking a bit more at the code revealed that we stick that in the
> @out.address_bits
> > 
> > > +     */
> > > +    struct xen_memory_reservation in;
> > > +
> > > +    /*
> > > +     * [IN/OUT] Details of new memory extents.
> > > +     * We require that:
> > > +     *  1. @in.domid == @out.domid
> > > +     *  2. @in.nr_extents  << @in.extent_order == 
> > > +     *     @out.nr_extents << @out.extent_order
> > > +     *  3. @in.extent_start and @out.extent_start lists must not overlap
> > > +     *  4. @out.extent_start lists GPFN bases to be populated
> > > +     *  5. @out.extent_start is overwritten with allocated GMFN bases
> 
> .. which you should document, otherwise the hypervisor might try to give
> you pages under 2^0..

Yes, you are right. I'll add a note about out.address_bits.


> > > +     */
> > > +    struct xen_memory_reservation out;
> > > +
> > > +    /*
> > > +     * [OUT] Number of input extents that were successfully exchanged:
> > > +     *  1. The first @nr_exchanged input extents were successfully
> > > +     *     deallocated.
> > > +     *  2. The corresponding first entries in the output extent list correctly
> > > +     *     indicate the GMFNs that were successfully exchanged.
> > > +     *  3. All other input and output extents are untouched.
> > > +     *  4. If not all input exents are exchanged then the return code of this
> > > +     *     command will be non-zero.
> > > +     *  5. THIS FIELD MUST BE INITIALISED TO ZERO BY THE CALLER!
> 
> as this says the initial value is zero.

This is referring to nr_exchanged.
