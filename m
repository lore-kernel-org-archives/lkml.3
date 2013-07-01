Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab3GAPiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:38:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53876 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab3GAPiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:38:13 -0400
Date: Mon, 1 Jul 2013 17:38:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@gmail.com>, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Message-ID: <20130701153805.GB23539@pd.tnic>
References: <20130621072725.GB22006@pd.tnic>
 <20130628120224.7781.45438.stgit@localhost.localdomain>
 <CA+8MBbJNY7G+q=kBgOA=+jVtugrfteoMvwLtfwvCno5xg+dm-Q@mail.gmail.com>
 <51D19B3F.3060405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51D19B3F.3060405@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 08:37:43PM +0530, Naveen N. Rao wrote:
> On 06/28/2013 11:01 PM, Tony Luck wrote:
> >>+                       if (sec_sev == GHES_SEV_CORRECTED &&
> >>+                           (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
> >>+                           (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
> >>+                               unsigned long pfn;
> >>+                               pfn = mem_err->physical_addr >> PAGE_SHIFT;
> >
> >As Reagan said "Trust ... but verify" ... we should make sure BIOS
> >gave us a good pfn
> >                                     if (pfn_valid(pfn))
> >                                          soft_memory_failure_queue(pfn, 0, 0);
> >                                     else
> >                                          printk( ...something about
> >BIOS giving us bad pfn = %lu\n", pfn);
> 
> Ah, nice catch - I thought soft_offline_page() takes care of this,
> but it sure is good to point a finger at the firmware.

While at it maybe make it pr_warning(FW_BUG or FW_WARN...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
