Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbaDPXLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:11:51 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:58086 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbaDPXLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:11:49 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBRAYHghJjfcG3aJK4LUEmUmr2w_y8qLodfgALrxX+-Bgw@mail.gmail.com>
References: <20140224162400.GE16457@pd.tnic> <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
 <1558044.S1G2VU7srO@vostro.rjw.lan> <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
 <20140416190404.GA7070@pd.tnic> <20140416203138.GA17661@google.com> <CABPqkBRAYHghJjfcG3aJK4LUEmUmr2w_y8qLodfgALrxX+-Bgw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 16 Apr 2014 17:11:28 -0600
Message-ID: <CAErSpo4uHcnw2yXmqTjd9w8QDa2gCDpzuZDgWCoZFT3VAd3KCg@mail.gmail.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
To: Stephane Eranian <eranian@google.com>
Cc: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 5:08 PM, Stephane Eranian <eranian@google.com> wrote:
> On Wed, Apr 16, 2014 at 1:31 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Wed, Apr 16, 2014 at 09:04:04PM +0200, Borislav Petkov wrote:
>>> On Thu, Mar 20, 2014 at 02:48:30PM -0600, Bjorn Helgaas wrote:
>>> > Right.  Even if we had this long-term solution, we'd still have
>>> > Stephane's current problem, because the PNP0C02 _CRS is still wrong.
>>> >
>>> > We do have a drivers/pnp/quirks.c where we could conceivably adjust
>>> > the PNP resource if we found the matching PCI device and MCHBAR.  That
>>> > should solve Stephane's problem even with the current
>>> > drivers/pnp/system.c.
>>>
>>> Guys, this still triggers in -rc1. Do we have a fix or something
>>> testable at least?
>>
>> Hi Boris,
>>
>> Can you try the patch below?
>>
>>
>>
>> PNP: Work around Haswell BIOS defect in MCH area reporting
>>
>> From: Bjorn Helgaas <bhelgaas@google.com>
>>
>> Work around a Haswell BIOS defect that causes part of the MCH area to be
>> unreported.
>>
>> MCHBAR is not an architected PCI BAR, so MCH space is usually reported as a
>> PNP0C02 resource.  The MCH space was 16KB prior to Haswell, but it is 32KB
>> in Haswell.  Some Haswell BIOSes still report a PNP0C02 resource that is
>> only 16KB, which means the rest of the MCH space is consumed but
>> unreported.
>>
> Why are you saying this is Haswell vs. others. I see the problem on my
> IvyBridge laptop, like Boris.

Ah, good question.  Somewhere I got pointed to the Haswell docs, which
say 32KB.  I don't know what other parts have 32KB MCH spaces.  If we
could figure out a list of device IDs with 32KB spaces, we could add
that to the quirk.

But I don't know how to come up with a complete list.

Bjorn
