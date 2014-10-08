Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaJHApc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:45:32 -0400
Received: from ozlabs.org ([103.22.144.67]:55011 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367AbaJHApb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:45:31 -0400
Message-ID: <1412729129.4133.2.camel@ale.ozlabs.ibm.com>
Subject: Re: [v3,12/16] cxl: Add base builtin support
From: Michael Neuling <mikey@neuling.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: greg@kroah.com, arnd@arndb.de, benh@kernel.crashing.org,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        imunsie@au.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Date: Wed, 08 Oct 2014 11:45:29 +1100
In-Reply-To: <20141007230416.2040C14011E@ozlabs.org>
References: <20141007230416.2040C14011E@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-08 at 10:04 +1100, Michael Ellerman wrote:
> On Tue, 2014-07-10 at 10:48:18 UTC, Michael Neuling wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > This adds the base cxl support that needs to be build into the kernel to use
> > cxl as a module. This is needed so that the cxl call backs from the core
> > powerpc mm code always exist irrespective of if the cxl module is loaded or
> > not. This is similar to how cell works with CONFIG_SPU_BASE.
> > 
> > This adds a cxl_slbia() call (similar to spu_flush_all_slbs()) which checks for
> > the cxl module being loaded. If the modules is not loaded we return, otherwise
> > we call into the cxl SLB invalidation code.
> > 
> > This also adds the cxl_ctx_in_use() function for use in the mm code to see if
> > any cxl contexts are currently in use. This is used by the tlbie() to
> > determine if it can do local TLB invalidations or not. This also adds get/put
> > calls for the cxl driver module to refcount the active cxl contexts.
> 
> This last paragraph is no longer true.

Yep, thanks.  I'll move it to patch 7 where it does apply.

Mikey

