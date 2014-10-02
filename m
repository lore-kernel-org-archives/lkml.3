Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaJBAmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 20:42:55 -0400
Received: from ozlabs.org ([103.22.144.67]:55505 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaJBAmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 20:42:54 -0400
Message-ID: <1412210571.19209.80.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH v2 02/17] powerpc/cell: Move data segment faulting code
 out of cell platform
From: Michael Neuling <mikey@neuling.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: greg@kroah.com, arnd@arndb.de, benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, jk@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu, 02 Oct 2014 10:42:51 +1000
In-Reply-To: <20141001064757.BFF88140174@ozlabs.org>
References: <20141001064757.BFF88140174@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 16:47 +1000, Michael Ellerman wrote:
> On Tue, 2014-30-09 at 10:34:51 UTC, Michael Neuling wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > __spu_trap_data_seg() currently contains code to determine the VSID and ESID
> > required for a particular EA and mm struct.
> > 
> > This code is generically useful for other co-processors.  This moves the code
> > of the cell platform so it can be used by other powerpc code.  It also adds 1TB
> > segment handling which Cell didn't have.
> 
> I'm not loving this.
> 
> For starters the name "copro_data_segment()" doesn't contain any verbs, and it
> doesn't tell me what it does.

Ok.

> If we give it a name that says what it does, we get copro_get_ea_esid_and_vsid().
> Or something equally ugly.

Ok

> And then in patch 10 you move the bulk of the logic into calculate_vsid().

That was intentional on my part.  I want this patch to be clear that
we're moving this code out of cell.  Then I wanted the optimisations to
be in a separate patch.  It does mean we touch the code twice in this
series, but I was hoping it would make it easier to review.  Alas. :-)

> So instead can we:
>  - add a small helper that does the esid calculation, eg. calculate_esid() ?
>  - factor out the vsid logic into a helper, calculate_vsid() ?
>  - rework the spu code to use those, dropping __spu_trap_data_seg()
>  - use the helpers in the cxl code

OK, I think I can do that.  I might change the name to something better
in this patch, but I'll leave these cleanups to the later patch 10.

Mikey

