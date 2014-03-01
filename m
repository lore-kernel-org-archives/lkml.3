Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaCAUG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 15:06:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35149 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbaCAUG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 15:06:58 -0500
Message-ID: <53123DCF.7040500@zytor.com>
Date: Sat, 01 Mar 2014 12:06:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <531027BE.2010807@linux.intel.com> <20140228061254.GA2226@srcf.ucam.org> <53102AB9.40600@linux.intel.com> <20140228062325.GA3246@srcf.ucam.org> <53102F3C.4020806@linux.intel.com> <20140228064413.GA4900@srcf.ucam.org> <531032A0.8090903@linux.intel.com> <5310CBB7.4030407@linux.intel.com> <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org>
In-Reply-To: <20140301172256.GA29417@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2014 09:22 AM, Matthew Garrett wrote:
> On Sun, Mar 02, 2014 at 01:10:46AM +0800, Li, Aubrey wrote:
> 
>> Peter - Can you please clarify writing to cf9 caused some system hang.
>> If CF9 is the last way to try, that means ACPI, KBD takes no effect,
>> then if no CF9, the system hangs there in  infinite for() loop. If CF9
>> is there, that means CF9 takes no effect as well, CF9 does *NOT* cause
>> system hang, right? If the answer is no, can you please point me which
>> system hangs by CF9. I'd like to investigate what the ACPI reboot
>> vectors look like on these systems.
> 
> I think I'm fine with cf9 being in there as long as it comes after the 
> ACPI calls and as long as we're using either conf1 or conf2 access.
> 

Be careful.  This is *exactly* what I tried back in checkin
14d7ca5c575853664d8fe4f225a77b8df1b7de7d.  We had to back that out quite
quickly.

This was before we had the Link: tags pointing back to the LKML
discussion, but the date (2008-11-11) and title of the patch should give
a good hint for finding the discussion I would think.

    x86: attempt reboot via port CF9 if we have standard PCI ports

    Impact: Changes reboot behavior.

    If port CF9 seems to be safe to touch, attempt it before trying the
    keyboard controller.  Port CF9 is not available on all chipsets (a
    significant but decreasing number of modern chipsets don't implement
    it), but port CF9 itself should in general be safe to poke (no ill
    effects if unimplemented) on any system which has PCI Configuration
    Method #1 or #2, as it falls inside the PCI configuration port range
    in both cases.  No chipset without PCI is known to have port CF9,
    either, although an explicit "pci=bios" would mean we miss this and
    therefore don't use port CF9.  An explicit "reboot=pci" can be used to
    force the use of port CF9.

    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

