Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaB1FWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:22:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:32627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaB1FWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:22:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="483332577"
Message-ID: <53101D1D.9010202@linux.intel.com>
Date: Fri, 28 Feb 2014 13:22:37 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Len.Brown@intel.com, Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53100C8D.1060001@linux.intel.com> <20140228045637.GA28257@srcf.ucam.org>
In-Reply-To: <20140228045637.GA28257@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/28 12:56, Matthew Garrett wrote:
> On Fri, Feb 28, 2014 at 12:11:57PM +0800, Li, Aubrey wrote:
>> This patch is to introduce BOOT_EFI and BOOT_CF9 in the reboot sequence
>> loop, to fix the reboot problem on the known Intel Bay Trail-T based
>> platform, for example, ASUS-T100 and Dell Venue 8/11 Pro. These
>> platforms don't support ACPI reboot, we expect to call EFI runtime
>> service to handle this case, and CF9 is an alternate after EFI.
> 
> EFI reboot is still somewhat unreliable - it may be safe after the 
> recent patches to provide a 1:1 mapping.

So it's acceptable to put EFI in the default list.


> CF9 is, as far as I know, not  part of any spec, so it seems like a bad
> idea to put it in the default list.

Any hurt known if put it in the default list?

> 
> What do the ACPI reboot vectors look like on these systems?

Reset register address: 0xCF9
Value to cause reset:   0x6

> 
>> - * 3) If still alive, write to the ACPI reboot register again
>> - * 4) If still alive, write to the keyboard controller again
>> + * 3) If still alive, call EFI runtime service
>> + * 4) If still alive, write to the PCI IO port 0xCF9
> 
> This is definitely incorrect. The ACPI write *must* occur twice in order 
> to be effective on various systems. EFI shouldn't be attempted until 
> after the second ACPI write.
> 

Do we have any spec mentioned that?

Thanks,
-Aubrey
