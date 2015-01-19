Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbbASLnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:43:25 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36693 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbbASLnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:43:23 -0500
Message-ID: <54BCEDD5.40301@redhat.com>
Date: Mon, 19 Jan 2015 12:43:17 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Wincy Van <fanwenyi0529@gmail.com>, gleb@kernel.org,
        yang.z.zhang@intel.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH 5/5] KVM: nVMX: Enable nested posted interrupt processing.
References: <CACzj_yWjkW0azZGEVHKkQZJWRjNykxCfBRz=tEA=d624WGzccw@mail.gmail.com>
In-Reply-To: <CACzj_yWjkW0azZGEVHKkQZJWRjNykxCfBRz=tEA=d624WGzccw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wincy,

there is only one thing that I don't understand in this patchset, and it is:

On 16/01/2015 06:59, Wincy Van wrote:
> +       /*
> +        * if vcpu is in L2, we are fast enough to complete
> +        * before L1 changes/destroys vmcs12.
> +        */

... this comment.  What do you mean exactly?

Paolo

> +       local_irq_save(flags);
> +       vmcs12 = get_vmcs12(vcpu);
> +       if (!is_guest_mode(vcpu) || !vmcs12) {
> +               r = -1;
> +               goto out;
> +       }
> +       if (vector == vmcs12->posted_intr_nv &&
> +           nested_cpu_has_posted_intr(vmcs12)) {
> +               if (vcpu->mode == IN_GUEST_MODE)
> +                       apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
> +                               POSTED_INTR_VECTOR);
> +               else {
> +                       r = -1;
> +                       goto out;
> +               }
> +
