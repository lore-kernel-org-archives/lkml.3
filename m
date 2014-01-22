Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaAVMDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:03:22 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57953 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbaAVMDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:03:19 -0500
Message-ID: <52DFB382.5080002@redhat.com>
Date: Wed, 22 Jan 2014 13:03:14 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
Subject: Re: [PATCH v3 0/4] X86/KVM: enable Intel MPX for KVM
References: <DE8DF0795D48FD4CA783C40EC82923350149FC1E@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350149FC1E@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/01/2014 06:29, Liu, Jinsong ha scritto:
> These patches are version 3 to enalbe Intel MPX for KVM.
>
> Version 1:
>   * Add some Intel MPX definiation
>   * Fix a cpuid(0x0d, 0) exposing bug, dynamic per XCR0 features enable/disable
>   * vmx and msr handle for MPX support at KVM
>   * enalbe MPX feature for guest
>
> Version 2:
>   * remove generic MPX definiation, Qiaowei's patch has add the definiation at kernel side
>   * add MSR_IA32_BNDCFGS to msrs_to_save
>
> Version 3:
>   * rebase on latest kernel, which include Qiaowei's MPX common definiation pulled from HPA's tree

I am afraid there is still some work to do on these patches, so they 
need to be delayed to 3.15.

Patch 1:
	this seems mostly separate from the rest of the MPX work.  I
	commented on the missing "ULL" suffix, but I would also like to
	understand why you put this patch in this series.

Patch 2:
	As remarked in the reply to this patch:
	- the vmx_disable_intercept_for_msr has to be unconditional
	- you need a new kvm_x86_ops member mpx_supported, to disable
	MPX whenever the two VMX controls are not available.

Patch 3:
	this patch needs to be rebased.  Apart from that it is fine,
	but please move the VMX bits together with patch 2, and the
	other bits together with patch 4.

Patch 4:
	this patch needs to be rebased and to use the new mpx_supported
	member

If you also want to look at nested VMX support for MPX, that would be 
nice.  It should not be hard.  Otherwise we can take care of that later.

Thanks for your work,

Paolo
