Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbaD1V2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:28:46 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:38591 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaD1V2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:28:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140420105419.GB19676@pd.tnic>
References: <20140419025308.2408.51252.stgit@amt.stowe>
	<20140419025345.2408.99229.stgit@amt.stowe>
	<20140420105419.GB19676@pd.tnic>
Date: Mon, 28 Apr 2014 15:28:43 -0600
Message-ID: <CAL-B5D23T3fSr=s=2T2LN-CaJn0u5rUaUxPOq+xdSdTU5KqE6Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] PCI: Remove redundant 'quirk_amd_nb_node'
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

On Sun, Apr 20, 2014 at 4:54 AM, Borislav Petkov <bp@suse.de> wrote:
> On Fri, Apr 18, 2014 at 08:53:46PM -0600, Myron Stowe wrote:
>> With the amd_bus.c updates to support additional AMD processors (11h, 12h,
>> 14h 15h  and 16h) 'quirk_amd_nb_node' seems to be redundant.  This patch
>> removes it.
>>
>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>
> Good idea. Has this been tested, though? There are a bunch of places
> using dev_to_node() which this quirk corrects, especially 'local_cpus'
> in a bunch of sysfs nodes in the PCI hierarchy /sys/devices/pci*.

My testing was related to the PCI hierarchy /sys/devices/pci* as this
was the root issue I'm trying to get resolved.

Daniel also responded - Thanks Dan! - indicating that the changes are
ok related to his concerns.

>
> We want to make sure this doesn't break that and other dev_to_node()
> callsites.

Agreed, which is at least in part why this is a separate patch.

I'm going to run some more testing and then post with most of your
comments incorporated.  Thanks again for the review.

Myron
>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
