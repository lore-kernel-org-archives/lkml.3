Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaD1VVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:21:53 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:60548 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaD1VVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:21:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140420080203.GB19672@pd.tnic>
References: <20140419025308.2408.51252.stgit@amt.stowe>
	<20140419025331.2408.40589.stgit@amt.stowe>
	<20140420080203.GB19672@pd.tnic>
Date: Mon, 28 Apr 2014 15:21:49 -0600
Message-ID: <CAL-B5D2yYyig6zEyjFHSiJrp83XL1SHuR=ETJMbp3uEVT9smhw@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] x86/PCI: Miscellaneous code clean up for early_fillup_mp_bus_info
From: Myron Stowe <myron.stowe@gmail.com>
To: Borislav Petkov <bp@suse.de>
Cc: Myron Stowe <myron.stowe@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        kim.naru@amd.com, daniel@numascale.com,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
        x86 <x86@kernel.org>, sp@numascale.com,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 2:02 AM, Borislav Petkov <bp@suse.de> wrote:
> On Fri, Apr 18, 2014 at 08:53:31PM -0600, Myron Stowe wrote:
>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>
>> * Refactoring of the early_fill_mp_bus_info function into multiple helper
>>   functions since it is getting long, and difficult to follow.
>
> Much better.
>

Yes, it had become too big!

>> * Merge early_fill_mp_bus_info into amd_postcore_init as there is no need to
>>   have this as a separate function.
>>
>> * Use pr_xxx instead of printk
>
> You can convert the printk(KERN_CONT -> pr_cont( too, while at it.
> Although, this would prepend the fmt thing on every line ...
>

Yeah, I ignored this since the additional pr_fmt() output was too
noisy and redundant

>> * Prepend "AMD-Bus" for each print.
>
> That's done with pr_fmt
>

Done

>> * The current code is using "fam10h_mmconf_*" in several place.  As this
>>   file is no longer specific to family10h systems, this patch changes
>>   such occurrances to "amd_mmconf_*" instead for clarity.
>
> ...
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
