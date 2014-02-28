Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaB1E4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:56:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39956 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaB1E4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:56:45 -0500
Date: Fri, 28 Feb 2014 04:56:37 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Len.Brown@intel.com, Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140228045637.GA28257@srcf.ucam.org>
References: <53100C8D.1060001@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53100C8D.1060001@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:11:57PM +0800, Li, Aubrey wrote:
> This patch is to introduce BOOT_EFI and BOOT_CF9 in the reboot sequence
> loop, to fix the reboot problem on the known Intel Bay Trail-T based
> platform, for example, ASUS-T100 and Dell Venue 8/11 Pro. These
> platforms don't support ACPI reboot, we expect to call EFI runtime
> service to handle this case, and CF9 is an alternate after EFI.

EFI reboot is still somewhat unreliable - it may be safe after the 
recent patches to provide a 1:1 mapping. CF9 is, as far as I know, not 
part of any spec, so it seems like a bad idea to put it in the default 
list.

What do the ACPI reboot vectors look like on these systems?

> - * 3) If still alive, write to the ACPI reboot register again
> - * 4) If still alive, write to the keyboard controller again
> + * 3) If still alive, call EFI runtime service
> + * 4) If still alive, write to the PCI IO port 0xCF9

This is definitely incorrect. The ACPI write *must* occur twice in order 
to be effective on various systems. EFI shouldn't be attempted until 
after the second ACPI write.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
