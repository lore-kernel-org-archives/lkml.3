Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3EHTIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:08:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50755 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab3EHTIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:08:43 -0400
Date: Wed, 8 May 2013 21:10:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, rostedt@goodmis.org, mchehab@redhat.com,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aerdrv: Move cper_print_pcie() out of interrupt context
Message-ID: <20130508191019.GG30955@pd.tnic>
References: <20130508171519.26724.63307.stgit@grignak.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130508171519.26724.63307.stgit@grignak.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 11:15:19AM -0600, Lance Ortiz wrote:
> The following warning was seen on 3.9 when a corrected PCIe error was being
> handled by the AER subsystem.
> 
> WARNING: at .../drivers/pci/search.c:214 pci_get_dev_by_id+0x8a/0x90()
> 
> This occurred because code was added to the function cper_print_pcie() that
> calls the pci_get_domain_bus_and_slot() function.  cper_print_pcie() is called
> in an interrupt context and pci_get* functions are not supposed to be called
> in that context hence the warning.
> 
> The solution is to move the call to cper_print_aer() out of the interrupt
> context and into aer_recover_queue() to avoid any warnings when calling
> pci_get* functions.
> 
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>

Looks good.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
