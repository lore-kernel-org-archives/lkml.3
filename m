Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700Ab3JPQGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:06:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47087 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551Ab3JPQGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:06:07 -0400
Date: Wed, 16 Oct 2013 18:05:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: tony.luck@intel.com, joe@perches.com, naveen.n.rao@linux.vnet.ibm.com,
        arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Extended H/W error log driver
Message-ID: <20131016160550.GG13608@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:55:57AM -0400, Chen, Gong wrote:
> [PATCH v2 1/9] ACPI, APEI, CPER: Fix status check during error printing
> [PATCH v2 2/9] ACPI, CPER: Update cper info
> [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
> [PATCH v2 4/9] ACPI, x86: Extended error log driver for x86 platform
> [PATCH v2 5/9] DMI: Parse memory device (type 17) in SMBIOS
> [PATCH v2 6/9] ACPI, APEI, CPER: Add UEFI 2.4 support for memory error
> [PATCH v2 7/9] ACPI, APEI, CPER: Enhance memory reporting capability
> [PATCH v2 8/9] ACPI, APEI, CPER: Cleanup CPER memory error output format
> [PATCH v2 9/9] ACPI / trace: Add trace interface for eMCA driver
> 
> This patch series adds an enhanced MCA event logging driver provided by Intel.
> Please refer to this link: htpp://www.intel.com/content/www/us/en/architecture-and-technology/enhanced-mca-logging-xeon-paper.html
> 
> Certain usages such as Predictive Failure Analysis (PFA) require more
> information about the error than what can be described in processor
> machine check banks. Most server processors log additional information
> about the error in processor uncore registers. Since the addresses
> and layout of these registers vary widely from one processor to another,
> system software cannot readily make use of them. To complicate matters
> further, some of the additionalerror information cannot be constructed

space between "additional" and "error".

> without detailed knowledge about platform topology. This enhanced MCA
> logging driver allows firmware to provide additional error information
> to MCE/CMCI handler and thus addresses this gap.

This paragraph sounds like a very good description of the feature and
should actually be the Kconfig text in patch 4/9.

> 
> After applying this patch series, when a memory corrected error happens,
> we can get following information:
> 
> dmesg output:
> 
> [  949.545817] {1}Hardware error detected on CPU15
> [  949.549786] {1}event severity: corrected
> [  949.549786] {1} Error 0, type: corrected
> [  949.549786] {1}  section_type: memory error
> [  949.549786] {1}  physical_address: 0x0000001057eb0000
> [  949.549786] {1}  DIMM location: Memriser3 CHANNEL A DIMM 0
> [  949.549786] {1}Above error has been corrected by h/w and require no further action
> [  949.549786] mce: [Hardware Error]: Machine check events logged
> [ 1010.902124] {2}Hardware error detected on CPU15
> [ 1010.906064] {2}event severity: corrected
> [ 1010.906064] {2} Error 0, type: corrected
> [ 1010.906064] {2}  section_type: memory error
> [ 1010.906064] {2}  physical_address: 0x0000001057eb0000
> [ 1010.906064] {2}  DIMM location: Memriser3 CHANNEL A DIMM 0
> [ 1010.906064] {2}Above error has been corrected by h/w and require no further action
> [ 1010.906064] mce: [Hardware Error]: Machine check events logged

Yep, looks almost very good. One nit: can you raise the action line
higher, like this:

> [  949.545817] {1}Hardware error detected on CPU15
> [  949.549786] {1}It has been corrected by h/w and requires no further action

<here come the error details>

I mean, this is only the printk output and with a userspace consumer of
the tracepoint, none of this will go to dmesg but in cases when there's
no userspace consumer, it is still readable and understandable.

> For trace output format we still need further discussion. In the last
> patch(support trace interface) I have to reserve previous Kconfig
> format because I find once I put trace_event interface in the module,
> it will not work. I will paste another trace patch(it only works when
> acpi_extlog is builtin) for your answer.

I think to be able to define TRACE_EVENTs in modules, you need
https://lwn.net/Articles/383362/

Steve, that still true?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
