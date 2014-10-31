Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbaJaUYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:24:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19914 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaJaUYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:24:09 -0400
Date: Fri, 31 Oct 2014 16:23:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Juergen Gross <jgross@suse.com>, hpa@zytor.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, stefan.bader@canonical.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH 01/17] x86: Make page cache mode a real type
Message-ID: <20141031202322.GB15935@laptop.dumpdata.com>
References: <1414764033-30011-1-git-send-email-jgross@suse.com>
 <1414764033-30011-2-git-send-email-jgross@suse.com>
 <20141031194207.GA15367@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031194207.GA15367@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 08:42:07PM +0100, Borislav Petkov wrote:
> On Fri, Oct 31, 2014 at 03:00:17PM +0100, Juergen Gross wrote:
> > At the moment there are a lot of places that handle setting or getting
> > the page cache mode by treating the pgprot bits equal to the cache mode.
> > This is only true because there are a lot of assumptions about the setup
> > of the PAT MSR. Otherwise the cache type needs to get translated into
> > pgprot bits and vice versa.
> > 
> > This patch tries to prepare for that by introducing a separate type
> > for the cache mode and adding functions to translate between those and
> > pgprot values.
> > 
> > To avoid too much performance penalty the translation between cache mode
> > and pgprot values is done via tables which contain the relevant
> > information.  Write-back cache mode is hard-wired to be 0, all other
> > modes are configurable via those tables. For large pages there are
> > translation functions as the PAT bit is located at different positions
> > in the ptes of 4k and large pages.
> > 
> > Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> > Signed-off-by: Juergen Gross <jgross@suse.com>
> 
> Just a clarification question: how is one to understand this attribution
> here? Is Stefan the original author, was he a reviewer, or? Because this
> SOB chain is misleading...

He was the first then Juergen took over. Should the SOB order be inversed?

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
