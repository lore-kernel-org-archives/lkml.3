Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab3FTU5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 16:57:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39201 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab3FTU5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 16:57:35 -0400
Date: Thu, 20 Jun 2013 22:57:26 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v2 1/2] mce: acpi/apei: Honour Firmware First for MCA
 banks listed in APEI HEST CMC
Message-ID: <20130620205726.GA20863@pd.tnic>
References: <20130619175438.2852.93449.stgit@localhost.localdomain>
 <20130620073943.GE32694@pd.tnic>
 <51C3531D.3000600@linux.vnet.ibm.com>
 <20130620192928.GD19877@pd.tnic>
 <51C36288.4050405@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51C36288.4050405@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 01:44:00AM +0530, Naveen N. Rao wrote:
> This won't work across cpu offline/online, right? We will end up
> _not_ enabling CMCI on certain banks where we should have.

Huh, don't understand. cmci_discover runs on each CPU. After you've run
hest_parse_cmc early during boot and cleared the mce_poll_banks bits,
nothing will set them again so CPU hotplug doesn't matter...

> Another thing: for hest_parse_cmc(), does the below look good?
> 
>         cmc = (struct acpi_hest_ia_corrected *)hest_hdr;
>         if (!cmc->enabled)
>                 return 0;
> 
> #define ACPI_HEST_PARSING_DONE 1
>         /*
>          * We expect HEST to provide a list of MC banks that
>          * report errors in firmware first mode.
>          */
>         if (!(cmc->flags & ACPI_HEST_FIRMWARE_FIRST) ||
> !cmc->num_hardware_banks)
>                 return ACPI_HEST_PARSING_DONE;
> 
> The return value doesn't really matter since we don't check it, but
> returning an error looked like the wrong thing to do as well.

I'd add a comment above the "return 1" statement to explain why I'm
doing this. It is much more verbose even than a well-named macro :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
