Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbbATHya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:54:30 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:60186 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbbATHy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:54:29 -0500
MIME-Version: 1.0
In-Reply-To: <54BE04F7.7030402@redhat.com>
References: <CACzj_yWjkW0azZGEVHKkQZJWRjNykxCfBRz=tEA=d624WGzccw@mail.gmail.com>
 <54BCEDD5.40301@redhat.com> <CACzj_yVTWDB6_JMsV_itHoOudBio1YgkBosBYz70O6JeQ6w_Ug@mail.gmail.com>
 <54BE04F7.7030402@redhat.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Tue, 20 Jan 2015 15:54:07 +0800
Message-ID: <CACzj_yUx7G=8GfaTNMA8bQt8_odHMwfoJf_XYsD4w-vARKGfvg@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: nVMX: Enable nested posted interrupt processing.
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: gleb@kernel.org, yang.z.zhang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 3:34 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> Hence, we can disable local interrupts while delivering nested posted
>> interrupts to make sure
>> we are faster than the destination vcpu. This is a bit tricky but it
>> an avoid that race. I think we
>> do not need to add a spin lock here. RCU does not fit this case, since
>> it will introduce a
>> new race window between the rcu handler and handle_vmptr**.
>>
>> I am wondering that whether there is a better way : )
>
> Why not just use a spinlock?
>

Hmm.. it seems that using a spinlock is the best way.
I think we can drop the local_irq_save and use a spinlock instead.
I can send v2 if it is necessary, any more ideas?


Thanks,

Wincy
