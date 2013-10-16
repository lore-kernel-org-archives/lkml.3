Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535Ab3JPJRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:17:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35413 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760266Ab3JPJQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:16:55 -0400
Date: Wed, 16 Oct 2013 11:16:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-ID: <20131016091640.GA13608@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131015165435.GA2777@naverao1-tp.ibm.com>
 <20131015170039.GF7908@pd.tnic>
 <525D7BCD.7080303@linux.vnet.ibm.com>
 <20131015214346.68718bcd.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131015214346.68718bcd.m.chehab@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 09:43:46PM -0300, Mauro Carvalho Chehab wrote:
> Using a custom typedef here seems problematic, as that can make userspace
> interface more complicated.

It is defined in a userspace header: include/uapi/linux/uuid.h

> > >>> +		char *fru_text,
> > >>> +		u64 error_count,
> > >>> +		u32 severity,
> > >>> +		u64 phy_addr,
> > >>> +		char *mem_loc),
> 
> By looking on the rest of the changes, the mem_loc can now contain the 
> right location of the memory error, including on what DIMM the error
> happened. It can also (optionally) contain the DIMM label.

No, dimm_loc contains the label.

> Also, userspace needs to know what's the granularity for the error
> that an eMCA driver will give, in order to adjust its policies.

u32 error_count

> If you don't create the EDAC nodes, it means that userspace doesn't
> have any glue about what error information will be provided.

Of course it does - it is a tracepoint. There's no need for EDAC at all
with eMCA present on the system.

> In any case, this is provided by the EDAC core functions that describe
> the memory in details. So, IMHO, get rid of EDAC is a big mistake.

No one said we're getting rid of EDAC - we're basically disabling its
services on machines with eMCA because we simply don't need it.

> It is also nice to allow the user to choose his preferred mechanism,
> when more than one is properly supported on a given system.

We did this with firmware-first reporting so I don't see any need
for user interaction. When you have eMCA on the system, you disable
everything else reporting memory errors and go to sleep. So, similar to
firmware first.

If eMCA turns out to have f*cked BIOS implementations - which I don't
doubt - then we can add a chicken bit similar to "acpi=nocmcff"

It is that simple.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
