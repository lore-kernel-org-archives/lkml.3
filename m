Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaIKJfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaIKJfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:35:04 -0400
Message-ID: <54116CBB.7050505@redhat.com>
Date: Thu, 11 Sep 2014 11:34:51 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 6/7] kvm, mem-hotplug: Unpin and remove kvm_arch->apic_access_page.
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com> <1410413886-32213-7-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1410413886-32213-7-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/09/2014 07:38, Tang Chen ha scritto:
> +	if (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm)) {
> +		struct page *page = gfn_to_page(vmx->vcpu.kvm,
> +				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> +		vmcs_write64(APIC_ACCESS_ADDR, page_to_phys(page));
> +		/*
> +		 * Do not pin apic access page in memory so that memory
> +		 * hotplug process is able to migrate it.
> +		 */
> +		put_page(page);
> +	}

Please reuse vcpu_reload_apic_access_page here, too.

Paolo
