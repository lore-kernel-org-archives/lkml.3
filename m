Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122Ab3DRN2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:28:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab3DRN22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:28:28 -0400
Subject: Re: KVM VM(windows xp) reseted when running geekbench for about 2 days
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Yan Vugenfirer <yvugenfi@redhat.com>
In-Reply-To: <20130418125532.GW8997@redhat.com>
Date: Thu, 18 Apr 2013 16:25:48 +0300
Cc: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>, kvm list <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Luonengjun <luonengjun@huawei.com>,
        Zanghongyong <zanghongyong@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wangrui (K)" <moon.wangrui@huawei.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <9C764699-6F9C-4AD8-A6C9-34D818753452@redhat.com>
References: <D3E216785288A145B7BC975F83A2ED103FE1E7A5@szxeml556-mbx.china.huawei.com> <20130418125532.GW8997@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 18, 2013, at 3:55 PM, Gleb Natapov wrote:

> On Thu, Apr 18, 2013 at 12:00:49PM +0000, Zhanghaoyu (A) wrote:
>> I start 10 VMs(windows xp), then running geekbench tool on them, about 2 days, one of them was reset,
>> I found the reset operation is done by
>> int kvm_cpu_exec(CPUArchState *env)
>> {
>>    ...
>>       switch (run->exit_reason)
>>       ...
>>        case KVM_EXIT_SHUTDOWN:
>>            DPRINTF("shutdown\n");
>>            qemu_system_reset_request();
>>            ret = EXCP_INTERRUPT;
>>            break;
>>    ...
>> }
>> 
>> KVM_EXIT_SHUTDOWN exit reason was set previously in triple fault handle handle_triple_fault().
>> 
> How do you know that reset was done here? This is not the only place
> where qemu_system_reset_request() is called.

Make sure XP is not set to auto-reset in case of BSOD. 

Best regards,
Yan.

> 
>> What causes the triple fault?
>> 
> Are you asking what is triple fault or why it happened in your case?
> For the former see here: http://en.wikipedia.org/wiki/Triple_fault
> For the later it is to late to tell after VM reset. You can run QEMU with
> -no-reboot -no-shutdown. VM will pause instead of rebooting and then you
> can examine what is going on.
> 
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

