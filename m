Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964771AbaDTICS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:02:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086AbaDTICJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:02:09 -0400
Date: Sun, 20 Apr 2014 10:02:03 +0200
From: Borislav Petkov <bp@suse.de>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        suravee.suthikulpanit@amd.com, aravind.gopalakrishnan@amd.com,
        kim.naru@amd.com, daniel@numascale.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, bp@suse.de,
        sp@numascale.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] x86/PCI: Miscellaneous code clean up for
 early_fillup_mp_bus_info
Message-ID: <20140420080203.GB19672@pd.tnic>
References: <20140419025308.2408.51252.stgit@amt.stowe>
 <20140419025331.2408.40589.stgit@amt.stowe>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140419025331.2408.40589.stgit@amt.stowe>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:53:31PM -0600, Myron Stowe wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> * Refactoring of the early_fill_mp_bus_info function into multiple helper
>   functions since it is getting long, and difficult to follow.

Much better.

> * Merge early_fill_mp_bus_info into amd_postcore_init as there is no need to
>   have this as a separate function.
> 
> * Use pr_xxx instead of printk

You can convert the printk(KERN_CONT -> pr_cont( too, while at it.
Although, this would prepend the fmt thing on every line ...

> * Prepend "AMD-Bus" for each print.

That's done with pr_fmt

> * The current code is using "fam10h_mmconf_*" in several place.  As this
>   file is no longer specific to family10h systems, this patch changes
>   such occurrances to "amd_mmconf_*" instead for clarity.

...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
