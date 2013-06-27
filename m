Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3F0UMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:12:13 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:64259 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3F0UMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:12:08 -0400
MIME-Version: 1.0
In-Reply-To: <51CC7EA1.1040509@wwwdotorg.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <51CA2B03.4080106@wwwdotorg.org> <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
 <51CB33BE.2020601@wwwdotorg.org> <20130626193158.GF9078@rocoto.smurfnet.nu> <51CC7EA1.1040509@wwwdotorg.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 27 Jun 2013 21:11:45 +0100
X-Google-Sender-Auth: BiZ_oP_JmYvK8kBjy2AhHLvmNCg
Message-ID: <CACxGe6s-TZoNUaRZ+XpAC83OGPWeg41L9F7YHYjpXVeLR6vbEw@mail.gmail.com>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 7:04 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/26/2013 01:31 PM, Leif Lindholm wrote:
>> On Wed, Jun 26, 2013 at 12:32:30PM -0600, Stephen Warren wrote:
>>>>> What about ARMv8? Is the intention to have a separate definition for the
>>>>> UEFI bindings on ARMv8, so that compatibility isn't an issue? What if a
>>>>> future version of UEFI allows LPAE usage?
>>>>
>>>> It is unlikely that will happen on v7 since newer versions of UEFI are
>>>> expected to remain backwards compatible with the current spec.
>>>
>>> The expectation of backwards-compatibility sounds nice, but it seems a
>>> little dangerous to outright rely on it.
>>>
>>> Even if not a regular compatible property, can we define a property that
>>> indicates the UEFI revision or revision of this DT binding, so that if
>>> we ever have to change it, there is some way of explicitly indicating
>>> which exact schema the DT corresponds to, rather than having to
>>> reverse-engineer it from the set of properties that "just happen" to be
>>> present in DT?
>>>
>>> This is rather like the firmware node discussion that happened recently,
>>> where we were expecting to represent a firmware (secure mode) interface
>>> by a DT node, which would have a compatible value, which in turn would
>>> convey information about which "OS" the secure firmware was running, and
>>> well as any potential SoC-/OEM-/board-specific interface provided by it.
>>>
>>> And who knows, what if UEFI gets replaced someday; presumably we'd want
>>> some way of explicitly stating "running under UEFI" vs. "running under
>>> something else"?
>>
>> To me, these concerns are all covered by the existence of the
>> efi-system-table node, and the version number that you can extract
>> from the table (mandatory in any UEFI implementation) located at that
>> address. There is no reverse-engineering involved.
>
> So, what you're saying is that the existence (or lack thereof) of the
> efi-system-table property is the indicator whether EFI is present? I
> guess if we assume that EFI will always evolve at least compatibly
> enough that the system table will always exist and be formatted
> identically at least to the extent of allowing the EFI version number to
> be parsed then that's workable. If that guarantee is broken, then we can
> always define a different property that points at the new format of the
> table.

Yes, that is what it means, and there is *immense* pressure from the
OEM market to not break that contract in a non-backwards-compatible
way.

g.
