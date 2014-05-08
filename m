Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaEHQWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:22:55 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:32801 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaEHQWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140508153722.GO32718@rric.localhost>
References: <1399489127-6961-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1399489127-6961-2-git-send-email-suravee.suthikulpanit@amd.com>
	<20140508085905.GK32718@rric.localhost>
	<20140508090148.GL32718@rric.localhost>
	<536B973B.2000207@amd.com>
	<20140508151402.GN32718@rric.localhost>
	<536BA0E3.4050709@amd.com>
	<20140508153722.GO32718@rric.localhost>
Date: Thu, 8 May 2014 10:22:51 -0600
Message-ID: <CAL-B5D0NpOoi-J44qnxjCiQ4mDZ=tP_qtaQT19AGS73o6u8DVw@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] x86/PCI: Fix PCI root numa_node info on AMD family15h
From: Myron Stowe <myron.stowe@gmail.com>
To: Robert Richter <rric@kernel.org>
Cc: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        Borislav Petkov <bp@suse.de>, Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 9:37 AM, Robert Richter <rric@kernel.org> wrote:
> On 08.05.14 10:21:07, Suravee Suthikulanit wrote:
>> The reason I put it all these comments here is because it took us a while to
>> discuss what to do with this file going forward. There were some confusions.
>> Therefore, I just want to document it here.

I agree.  Hopefully anyone getting into this in the future will be
able to find this thread in the archives as it has been enlightning

>>
>> Also, the check for (boot_cpu_data.x86 > 0x11) was needed because it should
>> not be done for family15h.
>
> Yes, the only functional change of this patch is adding the bridge and
> the family check, right? Basically:
>
> +       { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1600 },
>
> and
>
> +        /*
> +         * The following code is only supported until Fam11h.
> +         * Newer processors will depend on ACPI MCFG table instead.
> +         */
> +        if (boot_cpu_data.x86 > 0x11)
> +                return 0;
> +
>
> This patch should stripped down to only those changes with a
> split. And maybe this should be added to linux-stable?
>
> All other rework is a different story... Can be done on top of this,
> though I would drop it.

I understand Robert's reasoning to split out the core changes (as
denoted above).  However, I *would* tend to follow on with an
additional subsequent patch that has the rest of the content as it
cleans this area up (as opposed to dropping it all together).  It
makes the code a little clearer and is basically little to no risk (no
functional change).

Myron
>
> -Robert
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
