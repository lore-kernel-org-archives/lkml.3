Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaKYUhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:37:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35371 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaKYUgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:36:44 -0500
Date: Tue, 25 Nov 2014 15:36:34 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@suse.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
Message-ID: <20141125203634.GA6433@laptop.dumpdata.com>
References: <20141119205150.700188369@linuxfoundation.org>
 <20141119205153.916605840@linuxfoundation.org>
 <5474C67A.7040200@oracle.com>
 <20141125182410.GB4128@pd.tnic>
 <5474CDCE.6040000@oracle.com>
 <20141125184351.GC4128@pd.tnic>
 <5474D0A1.2020600@oracle.com>
 <20141125190849.GF4128@pd.tnic>
 <5474D86E.6020608@oracle.com>
 <20141125202628.GG4128@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125202628.GG4128@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 09:26:28PM +0100, Borislav Petkov wrote:
> On Tue, Nov 25, 2014 at 02:28:46PM -0500, Boris Ostrovsky wrote:
> > You'd have to decide at runtime --- many baremetal systems are
> > compiled with PARAVIRT.
> 
> Right, but the microcode loader is not used at all on PV, right?

Is there an use-case for this in virtualization at all?
> 
> If so, I'd like to add a arch_something_blabla_disabled_loader()
> function which is run in the loader init path and returns false on
> baremetal and a true when running as a xen guest. I'm not sure how the
> detection should be done, though... CPUID with the hypervisor leaf?

Why not make it in general then? Like:

if (cpu_has_hypervisor)
	return;

?

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
