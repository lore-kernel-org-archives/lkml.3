Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaHVKDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:03:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbaHVKDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:03:36 -0400
Date: Fri, 22 Aug 2014 18:04:56 +0800
From: Dave Young <dyoung@redhat.com>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>,
        "Lv Zheng (zetalog@gmail.com)" <zetalog@gmail.com>
Subject: Re: kernel boot fail with efi earlyprintk (bisected)
Message-ID: <20140822100456.GB1877@darkstar.nay.redhat.com>
References: <20140819081658.GA1795@darkstar.nay.redhat.com>
 <20140821205224.GJ29733@console-pimps.org>
 <1AE640813FDE7649BE1B193DEA596E880265F008@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E880265F008@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/14 at 05:55am, Zheng, Lv wrote:
> Hi,
> 
> I checked the arch/x86/platform/efi/early_printk.c.
> In early_efi_scroll_up(), 2 mapping entries will be used for the src/dst screen buffer.
> In drivers/acpi/acpica/tbutils.c, we've improved the early table loading code in acpi_tb_parse_root_table().
> We now need 2 mapping entries:
> 1. One mapping entry is used for RSDT table mapping. Each RSDT entry contains an address for another ACPI table.
> 2. For each entry in RSDP, we need another mapping entry to map the table to perform necessary check/override before installing it.
> 
> When acpi_tb_parse_root_table() prints something through EFI earlyprintk console, we'll have 4 mapping entries used.
> The current 4 slots setting of early_ioremap() seems to be too small for such a use case.
> 
> I'm not 100% sure if this is the cause.
> If it's the cause and we think both of the mappings are reasonable, we can simply increase the FIX_BITMAPS_SLOTS defined in arch/x86/include/asm/fixmap.h.

Hmm, will give see if I can do more debug, I can try what you suggested.

Thanks
Dave
