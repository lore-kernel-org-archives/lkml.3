Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaHTINP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:13:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36964 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaHTINM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:13:12 -0400
Message-ID: <53F45893.6050305@redhat.com>
Date: Wed, 20 Aug 2014 10:13:07 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] KVM: vmx: fix ept reserved bits for 1-GByte page
References: <1408519913-8943-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1408519913-8943-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/08/2014 09:31, Wanpeng Li ha scritto:
> EPT misconfig handler in kvm will check which reason lead to EPT
> misconfiguration after vmexit. One of the reasons is that an EPT
> paging-structure entry is configured with settings reserved for
> future functionality. However, the handler can't identify if
> paging-structure entry of reserved bits for 1-GByte page are
> configured, since PDPTE which point to 1-GByte page will reserve
> bits 29:12 instead of bits 7:3 which are reserved for PDPTE that
> references an EPT Page Directory. This patch fix it by reserve
> bits 29:12 for 1-GByte page.

Thanks, the patch looks good.

Can you describe how you detected the problem and how you're testing for it?

Paolo
