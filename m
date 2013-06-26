Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3FZScf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:32:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51808 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3FZScd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:32:33 -0400
Message-ID: <51CB33BE.2020601@wwwdotorg.org>
Date: Wed, 26 Jun 2013 12:32:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org> <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org> <51CA2B03.4080106@wwwdotorg.org> <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
In-Reply-To: <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 07:20 AM, Grant Likely wrote:
> On Wed, Jun 26, 2013 at 12:42 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 06/25/2013 12:11 PM, Leif Lindholm wrote:
>>> This patch provides documentation of the [U]EFI runtime services and
>>> configuration features.
>>
>>
>>> diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
>>
>>> +The implementation depends on receiving pointers to the UEFI memory map
>>> +and System Table in a Flattened Device Tree - so is only available with
>>> +CONFIG_OF.
>>> +
>>> +It (early) parses the FDT for the following parameters:
>>
>> Part of this document (the raw requirements for DT content, rather than
>> the discussion of OS implementation/behaviour in parsing/interpreting
>> the properties) should be part of a file in
>> Documentation/devicetree/bindings/ (arm/uefi.txt?).
>>
>> What node are these properties expected to be contained within?
>>
>> Shouldn't that node be required to contain a compatible value, which
>> would define the schema for the other properties?
> 
> Typically, a compatible property isn't only used for nodes that
> represent a device or a so-called 'virtual' device (ie. such as to
> describe how all the sound complex is wired together) since that
> should be the clue to an OS that a device driver will bind against the
> node. I think these properties can be dropped into /chosen without
> defining a new compatible value.
> 
>>> +- 'efi-system-table':
>>> +  Physical address of the system table. (required)
>>> +- 'efi-runtime-mmap':
>>> +  Physical address of an EFI memory map, containing at least
>>> +  the regions to be preserved. (required)
>>> +- 'efi-runtime-mmap-size':
>>> +  Size in bytes of the provided memory map. (required)
>>> +- 'efi-mmap-desc-size':
>>> +  Size of each descriptor in the memory map. (override default)
>>> +- 'efi-mmap-desc-ver':
>>> +  Memory descriptor format version. (override default)
>>> +
>>> +Since UEFI firmware on ARM systems are required to use a 1:1 memory map
>>> +even on LPAE-capable systems, the above fields are 32-bit regardless.
>>
>> What about ARMv8? Is the intention to have a separate definition for the
>> UEFI bindings on ARMv8, so that compatibility isn't an issue? What if a
>> future version of UEFI allows LPAE usage?
> 
> It is unlikely that will happen on v7 since newer versions of UEFI are
> expected to remain backwards compatible with the current spec.

The expectation of backwards-compatibility sounds nice, but it seems a
little dangerous to outright rely on it.

Even if not a regular compatible property, can we define a property that
indicates the UEFI revision or revision of this DT binding, so that if
we ever have to change it, there is some way of explicitly indicating
which exact schema the DT corresponds to, rather than having to
reverse-engineer it from the set of properties that "just happen" to be
present in DT?

This is rather like the firmware node discussion that happened recently,
where we were expecting to represent a firmware (secure mode) interface
by a DT node, which would have a compatible value, which in turn would
convey information about which "OS" the secure firmware was running, and
well as any potential SoC-/OEM-/board-specific interface provided by it.

And who knows, what if UEFI gets replaced someday; presumably we'd want
some way of explicitly stating "running under UEFI" vs. "running under
something else"?
