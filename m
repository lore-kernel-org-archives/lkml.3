Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaKCQ6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:58:02 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:42059 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaKCQ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:57:51 -0500
Message-ID: <1415033030.29109.13.camel@misato.fc.hp.com>
Subject: Re: [PATCH V6 00/18] x86: Full support of PAT
From: Toshi Kani <toshi.kani@hp.com>
To: Juergen Gross <jgross@suse.com>
Cc: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        bhelgaas@google.com
Date: Mon, 03 Nov 2014 09:43:50 -0700
In-Reply-To: <1415019724-4317-1-git-send-email-jgross@suse.com>
References: <1415019724-4317-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 14:01 +0100, Juergen Gross wrote:
> The x86 architecture offers via the PAT (Page Attribute Table) a way to
> specify different caching modes in page table entries. The PAT MSR contains
> 8 entries each specifying one of 6 possible cache modes. A pte references one
> of those entries via 3 bits: _PAGE_PAT, _PAGE_PWT and _PAGE_PCD.
> 
> The Linux kernel currently supports only 4 different cache modes. The PAT MSR
> is set up in a way that the setting of _PAGE_PAT in a pte doesn't matter: the
> top 4 entries in the PAT MSR are the same as the 4 lower entries.
> 
> This results in the kernel not supporting e.g. write-through mode. Especially
> this cache mode would speed up drivers of video cards which now have to use
> uncached accesses.
> 
> OTOH some old processors (Pentium) don't support PAT correctly and the Xen
> hypervisor has been using a different PAT MSR configuration for some time now
> and can't change that as this setting is part of the ABI.
> 
> This patch set abstracts the cache mode from the pte and introduces tables to
> translate between cache mode and pte bits (the default cache mode "write back"
> is hard-wired to PAT entry 0). The tables are statically initialized with
> values being compatible to old processors and current usage. As soon as the
> PAT MSR is changed (or - in case of Xen - is read at boot time) the tables are
> changed accordingly. Requests of mappings with special cache modes are always
> possible now, in case they are not supported there will be a fallback to a
> compatible but slower mode.
> 
> Summing it up, this patch set adds the following features:
> - capability to support WT and WP cache modes on processors with full PAT
>   support
> - processors with no or uncorrect PAT support are still working as today, even
>   if WT or WP cache mode are selected by drivers for some pages
> - reduction of Xen special handling regarding cache mode
> 
> Changes in V6:
> - add new patch 10 (x86: Remove looking for setting of _PAGE_PAT_LARGE in
>   pageattr.c) as suggested by Thomas Gleixner
> - replaced SOB of Stefan Bader by "Based-on-patch-by:" as suggested by
>   Borislav Petkov

For patch 01/18 to 16/18:

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


