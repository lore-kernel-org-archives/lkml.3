Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab3LKJxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:53:23 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:34141 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3LKJxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:53:16 -0500
Message-ID: <52A83606.40908@redhat.com>
Date: Wed, 11 Dec 2013 10:53:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] X86/KVM: enable Intel MPX for KVM
References: <1386394315-48984-1-git-send-email-jinsong.liu@intel.com> <DE8DF0795D48FD4CA783C40EC82923350141B4A7@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350141B4A7@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/12/2013 09:31, Liu, Jinsong ha scritto:
> Paolo, comments for version 2?

I think I commented that it's fine, I'm just waiting for a rebase on top
of the generic patches.

Paolo

> Thanks,
> Jinsong
> 
> Liu, Jinsong wrote:
>> These patches are version 2 to enalbe Intel MPX for KVM.
>>
>> Version 1:
>>   * Add some Intel MPX definiation
>>   * Fix a cpuid(0x0d, 0) exposing bug, dynamic per XCR0 features
>> enable/disable 
>>   * vmx and msr handle for MPX support at KVM
>>   * enalbe MPX feature for guest
>>
>> Version 2:
>>   * remove generic MPX definiation, kernel side has add the
>> definiation 
>>   * add MSR_IA32_BNDCFGS to msrs_to_save
>>
>> Thanks,
>> Jinsong
>>
>> Liu Jinsong (4):
>>   KVM/X86: Fix xsave cpuid exposing bug
>>   KVM/X86: Intel MPX vmx and msr handle
>>   KVM/X86: add MSR_IA32_BNDCFGS to msrs_to_save
>>   KVM/X86: Enable Intel MPX for guest.
>>
>>  arch/x86/include/asm/vmx.h            |    4 ++++
>>  arch/x86/include/asm/xsave.h          |    2 ++
>>  arch/x86/include/uapi/asm/msr-index.h |    1 +
>>  arch/x86/kvm/cpuid.c                  |    8 ++++----
>>  arch/x86/kvm/vmx.c                    |   18 ++++++++++++++++--
>>  arch/x86/kvm/x86.c                    |   12 +++++++++---
>>  arch/x86/kvm/x86.h                    |    3 ++-
>>  7 files changed, 38 insertions(+), 10 deletions(-)
> 

