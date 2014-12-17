Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaLQRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:09:56 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41955 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaLQRJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:09:55 -0500
Message-ID: <5491B8DD.5020000@redhat.com>
Date: Wed, 17 Dec 2014 18:09:49 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: Re: [v3 24/26] KVM: Update Posted-Interrupts Descriptor when vCPU
 is blocked
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-25-git-send-email-feng.wu@intel.com>
In-Reply-To: <1418397300-10870-25-git-send-email-feng.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/2014 16:14, Feng Wu wrote:
> This patch updates the Posted-Interrupts Descriptor when vCPU
> is blocked.
> 
> pre-block:
> - Add the vCPU to the blocked per-CPU list
> - Clear 'SN'

Should SN be already clear (and NV set to POSTED_INTR_VECTOR)?  Can it
happen that you go from sched-out to blocked without doing a sched-in first?

In fact, if this is possible, what happens if vcpu->preempted &&
vcpu->blocked?

> - Set 'NV' to POSTED_INTR_WAKEUP_VECTOR
> 
> post-block:
> - Remove the vCPU from the per-CPU list

Paolo

> Signed-off-by: Feng Wu <feng.wu@intel.com>
