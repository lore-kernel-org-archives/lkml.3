Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966714Ab3DRMBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:01:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:17812 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965102Ab3DRMBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:01:12 -0400
From: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
To: kvm list <kvm@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Luonengjun <luonengjun@huawei.com>, Zanghongyong <zanghongyong@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Wangrui (K)" <moon.wangrui@huawei.com>
Subject: KVM VM(windows xp) reseted when running geekbench for about 2 days
Thread-Topic: KVM VM(windows xp) reseted when running geekbench for about 2
 days
Thread-Index: Ac48LEpguUL++1wxQxiPGnnKCoktbg==
Date: Thu, 18 Apr 2013 12:00:49 +0000
Message-ID: <D3E216785288A145B7BC975F83A2ED103FE1E7A5@szxeml556-mbx.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.135.68.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I start 10 VMs(windows xp), then running geekbench tool on them, about 2 days, one of them was reset,
I found the reset operation is done by
int kvm_cpu_exec(CPUArchState *env)
{
    ...
       switch (run->exit_reason)
       ...
        case KVM_EXIT_SHUTDOWN:
            DPRINTF("shutdown\n");
            qemu_system_reset_request();
            ret = EXCP_INTERRUPT;
            break;
    ...
}

KVM_EXIT_SHUTDOWN exit reason was set previously in triple fault handle handle_triple_fault().

What causes the triple fault?

Thanks,
Zhang Haoyu
