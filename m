Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbbATIEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:04:36 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51169 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbbATIEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:04:34 -0500
Message-ID: <54BE0C0E.3040902@redhat.com>
Date: Tue, 20 Jan 2015 09:04:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>
CC: gleb@kernel.org, yang.z.zhang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH 5/5] KVM: nVMX: Enable nested posted interrupt processing.
References: <CACzj_yWjkW0azZGEVHKkQZJWRjNykxCfBRz=tEA=d624WGzccw@mail.gmail.com> <54BCEDD5.40301@redhat.com> <CACzj_yVTWDB6_JMsV_itHoOudBio1YgkBosBYz70O6JeQ6w_Ug@mail.gmail.com> <54BE04F7.7030402@redhat.com> <CACzj_yUx7G=8GfaTNMA8bQt8_odHMwfoJf_XYsD4w-vARKGfvg@mail.gmail.com>
In-Reply-To: <CACzj_yUx7G=8GfaTNMA8bQt8_odHMwfoJf_XYsD4w-vARKGfvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 20/01/2015 08:54, Wincy Van wrote:
> On Tue, Jan 20, 2015 at 3:34 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>> Hence, we can disable local interrupts while delivering nested posted
>>> interrupts to make sure
>>> we are faster than the destination vcpu. This is a bit tricky but it
>>> an avoid that race. I think we
>>> do not need to add a spin lock here. RCU does not fit this case, since
>>> it will introduce a
>>> new race window between the rcu handler and handle_vmptr**.
>>>
>>> I am wondering that whether there is a better way : )
>>
>> Why not just use a spinlock?
>>
> 
> Hmm.. it seems that using a spinlock is the best way.
> I think we can drop the local_irq_save and use a spinlock instead.
> I can send v2 if it is necessary, any more ideas?

Yes, please send v2 of this patch only.

Paolo
