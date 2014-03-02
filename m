Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbaCBXMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:12:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43014 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbaCBXMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:12:06 -0500
Date: Sun, 2 Mar 2014 23:11:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140302231154.GA20891@srcf.ucam.org>
References: <53127C4B.1060505@zytor.com>
 <53128DA0.9060105@linux.intel.com>
 <53129256.6060704@zytor.com>
 <20140302022334.GA1131@srcf.ucam.org>
 <c4f4929e-6bab-45b9-ac6b-cbdea5fd57e8@email.android.com>
 <53130A46.1010801@linux.intel.com>
 <cfbdc582-9fc0-4335-9974-d508c2da1c71@email.android.com>
 <5313AD1B.6050403@linux.intel.com>
 <20140302222654.GA17838@srcf.ucam.org>
 <5313B47B.6020402@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5313B47B.6020402@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 06:45:15AM +0800, Li, Aubrey wrote:

> One example in my hand is, 32bit windows calls 32bit EFI firware, so
> reboot works. However, I installed 64bit linux on this 32bit EFI
> machine, so none of ACPI/KBD/EFI works.

Yes. The correct fix for that is to ensure that the 64-bit kernel can 
make 32-bit runtime services calls.

> Other cases even if we figured out why ACPI/KBD/EFI don't work, we still
> have to make our change in the linux kernel, because we can't change
> firmware.

That's correct, yes. If Windows is able to reboot the system and Linux 
is not, then that's a bug in the Linux kernel.

> So, if you are still suggesting we add EFI only, please let me know your
> plan about adding dmidecode table and if it's acceptable to add new
> tables, I have three waiting: ASUS-T100, Dell Venue 8 Pro, and Dell
> Venue 11 Pro.

I don't think it's acceptable to add DMI entries to the reboot table. I 
think you should add the EFI call (since we expect that to work now), 
and I have no objection to adding cf9 to the end of the list if we have 
standard PCI io ports (Windows doesn't do it, but we can hardly make 
things worse).

-- 
Matthew Garrett | mjg59@srcf.ucam.org
