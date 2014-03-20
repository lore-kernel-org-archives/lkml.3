Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbaCTUsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:48:53 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57405 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328AbaCTUsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <1558044.S1G2VU7srO@vostro.rjw.lan>
References: <20140224162400.GE16457@pd.tnic> <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com> <1558044.S1G2VU7srO@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 20 Mar 2014 14:48:30 -0600
Message-ID: <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 2:55 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, March 20, 2014 10:45:52 AM Bjorn Helgaas wrote:
>> The purpose of system.c is indeed to prevent resources from being
>> allocated to other devices.  This is really a question for Rafael, but
>> in my opinion this function (reserving resources of PNP/ACPI devices
>> to prevent their allocation to other devices) should be done for *all*
>> PNP and ACPI devices, not just the PNP0C01/PNP0C02 devices handled by
>> system.c.
>>
>> So I think the best solution would be to move that into the ACPI core
>> somehow so it happens for all devices.
>
> Well, I think you got to the bottom of this, but that's something we can
> do long-term.  Still, we need to find a short-term solution for the
> particular issue at hand.

Right.  Even if we had this long-term solution, we'd still have
Stephane's current problem, because the PNP0C02 _CRS is still wrong.

We do have a drivers/pnp/quirks.c where we could conceivably adjust
the PNP resource if we found the matching PCI device and MCHBAR.  That
should solve Stephane's problem even with the current
drivers/pnp/system.c.

Bjorn
