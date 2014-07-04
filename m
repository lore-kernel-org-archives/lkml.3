Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbaGDJiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:38:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbaGDJiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:38:20 -0400
Message-ID: <53B67602.4040604@redhat.com>
Date: Fri, 04 Jul 2014 11:38:10 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>, Bandan Das <bsd@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com> <53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com> <20140703065955.GA4236@kernel> <jpgk37u8iae.fsf@redhat.com> <20140704025250.GA2849@kernel> <53B63EF2.6000800@siemens.com> <53B674CD.2090906@siemens.com>
In-Reply-To: <53B674CD.2090906@siemens.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2014 11:33, Jan Kiszka ha scritto:
>
> The compiler is not aware of the fact that push/pop exists in this
> function and, thus, places the vmcs parameter on the stack without
> reserving the space. So the pushfq will overwrite the vmcs pointer and
> let the function fail.

Is that just a missing "memory" clobber?  push/pop clobbers memory.

Paolo
