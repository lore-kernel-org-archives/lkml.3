Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3FXD7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 23:59:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:52187 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab3FXD7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 23:59:19 -0400
Message-ID: <1372046300.3944.131.camel@pasglop>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Alexander Graf <agraf@suse.de>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Date: Mon, 24 Jun 2013 13:58:20 +1000
In-Reply-To: <20130624035426.GE25265@voom.fritz.box>
References: <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>
	 <1371653443.21896.291.camel@pasglop>
	 <1371656989.22659.98.camel@ul30vt.home> <51C28BEA.8050501@ozlabs.ru>
	 <20130620052822.GB3140@voom.redhat.com> <1371714449.3944.14.camel@pasglop>
	 <51C2C1CC.9000003@ozlabs.ru> <1371740113.32709.22.camel@ul30vt.home>
	 <20130622120304.GB25265@voom.fritz.box> <1371943693.3944.104.camel@pasglop>
	 <20130624035426.GE25265@voom.fritz.box>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 13:54 +1000, David Gibson wrote:
> > DDW means an API by which the guest can request the creation of
> > additional iommus for a given device (typically, in addition to the
> > default smallish 32-bit one using 4k pages, the guest can request
> > a larger window in 64-bit space using a larger page size).
> 
> So, would a PAPR gest requesting this expect the new window to have
> a new liobn, or an existing liobn?

New liobn or there is no way to H_PUT_TCE it (it exists in addition
to the legacy window).

Cheers,
Ben.


