Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaIODeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 23:34:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaIODeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 23:34:14 -0400
Date: Mon, 15 Sep 2014 11:33:55 +0800
From: Dave Young <dyoung@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@acpica.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, robert.moore@intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH RFC] x86 early_ioremap: increase FIX_BTMAPS_SLOTS to 8
Message-ID: <20140915033355.GB2700@darkstar.nay.redhat.com>
References: <20140826090641.GA16550@darkstar.nay.redhat.com>
 <20140914141412.GJ18582@console-pimps.org>
 <20140915023805.GA2700@darkstar.nay.redhat.com>
 <20140915024205.GA2561@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915024205.GA2561@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/14 at 07:42pm, Greg KH wrote:
> On Mon, Sep 15, 2014 at 10:38:05AM +0800, Dave Young wrote:
> > On 09/14/14 at 03:14pm, Matt Fleming wrote:
> > > On Tue, 26 Aug, at 05:06:41PM, Dave Young wrote:
> > > > 3.16 kernel boot fail with earlyprintk=efi, it keeps scrolling at the
> > > > bottom line of screen.
> > > > 
> > > > Bisected, the first bad commit is below:
> > > > commit 86dfc6f339886559d80ee0d4bd20fe5ee90450f0
> > > > Author: Lv Zheng <lv.zheng@intel.com>
> > > > Date:   Fri Apr 4 12:38:57 2014 +0800
> > > > 
> > > >     ACPICA: Tables: Fix table checksums verification before installation.
> > > 
> > > [...]
> > > 
> > > > Quote reply from Lv.zheng about the early ioremap slot usage in this case:
> > > > 
> > > > """
> > > > In early_efi_scroll_up(), 2 mapping entries will be used for the src/dst screen buffer.
> > > > In drivers/acpi/acpica/tbutils.c, we've improved the early table loading code in acpi_tb_parse_root_table().
> > > > We now need 2 mapping entries:
> > > > 1. One mapping entry is used for RSDT table mapping. Each RSDT entry contains an address for another ACPI table.
> > > > 2. For each entry in RSDP, we need another mapping entry to map the table to perform necessary check/override before installing it.
> > > > 
> > > > When acpi_tb_parse_root_table() prints something through EFI earlyprintk console, we'll have 4 mapping entries used.
> > > > The current 4 slots setting of early_ioremap() seems to be too small for such a use case.
> > > > """
> > > > 
> > > > Thus increase the slot to 8 in this patch to fix this issue.
> > > > boot-time mappings become 512 page with this patch.
> > >  
> > > This analysis and solution makes sense to me, but I was really hoping
> > > for one of the x86 maintainers to ACK the below patch. I'm happy to take
> > > it through the EFI tree if it's not picked up into tip meanwhile.
> > > 
> > > Also, Dave, it sounds like this should be tagged for stable if the bug
> > > has been around since v3.16?
> > 
> > Matt, yes, it should be a stable issue, ccing Greg and stable list.
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>

Frankly I did not know the exact work flow about stable patches. Thanks for
pointing me the documentation. I was just assuming I should cc your guys 
about the issues which could be stable candidate even though it has not been
accepted now, so it can get noticed by stable people.

Thanks
Dave
