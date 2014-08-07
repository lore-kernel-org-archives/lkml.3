Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaHGHHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 03:07:54 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51650 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaHGHHx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 03:07:53 -0400
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com> <CAKv+Gu83+OtTkM+tEkB4AKpqHg2qGXtfAxC-pQq0u9ez+VjwaA@mail.gmail.com> <20140807012847.GB20295@darkstar.nay.redhat.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20140807012847.GB20295@darkstar.nay.redhat.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <7F205346-C978-4FC1-8812-2A37AFA06312@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (11D257)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
Date: Thu, 7 Aug 2014 09:07:51 +0200
To: Dave Young <dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 7 aug. 2014, at 03:28, Dave Young <dyoung@redhat.com> wrote:
> 
>> On 08/06/14 at 02:40pm, Ard Biesheuvel wrote:
>>> On 6 August 2014 10:38, Dave Young <dyoung@redhat.com> wrote:
>>> 
>>> Adding a noefi boot param like in X86 to disable efi runtime services support.
>>> 
>>> This will be useful for debugging uefi problems. Also it will be useful
>>> for later kexec/kdump work. Kexec on uefi support in X86 depends on a fixed vm
>>> area specific for uefi runtime 1:1 mapping, kernel will switch to a different
>>> page table for any uefi runtime callback in virtual mode. In arm64 similar
>>> work probably is necessary. But kexec boot will just works with 'noefi' with
>>> the limitaion of lacking runtime services. The runtime services is not critical
>>> for kdump kernel for now. So as for kexec/kdump just leave the 1:1 mapping a
>>> future work.
>> 
>> Can we find a better name? You will still be using the UEFI memory map
>> rather than the DT memory nodes (which will have been deleted by the
>> stub), and things like SMBIOS and ACPI that hinge off UEFI remain
>> enabled as well.
> Hi, Ard
> 
> Leif suggested efi=noruntime, I think that will be better to you?
> 

Yes, that sounds perfect to me

Ard.

> Thanks for review.
> Dave
