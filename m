Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936806Ab3DHKu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:50:58 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:42307 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934464Ab3DHKu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:50:56 -0400
Date: Mon, 8 Apr 2013 12:50:52 +0200
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        Zanghongyong <zanghongyong@huawei.com>,
        Luonengjun <luonengjun@huawei.com>,
        Zhanghuanzhong <zhanghuanzhong@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUWVtdS1kZXZlbA==?= =?utf-8?Q?=5D?= qemu
 crashed when starting vm(kvm) with vnc connect
Message-ID: <20130408105052.GC12076@stefanha-thinkpad.redhat.com>
References: <D3E216785288A145B7BC975F83A2ED103FE154C1@szxeml556-mbx.china.huawei.com>
 <20130405063456.GA27569@stefanha-thinkpad.redhat.com>
 <D3E216785288A145B7BC975F83A2ED103FE16528@szxeml556-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D3E216785288A145B7BC975F83A2ED103FE16528@szxeml556-mbx.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 07, 2013 at 04:58:07AM +0000, Zhanghaoyu (A) wrote:
> >> I start a kvm VM with vnc(using the zrle protocol) connect, sometimes qemu program crashed during starting period, received signal SIGABRT.
> >> Trying about 20 times, this crash may be reproduced.
> >> I guess the cause memory corruption or double free.
> >
> > Which version of QEMU are you running?
> > 
> > Please try qemu.git/master.
> > 
> > Stefan
> 
> I used the QEMU download from qemu.git (http://git.qemu.org/git/qemu.git).

Great, thanks!  Can you please post a backtrace?

The easiest way is:

  $ ulimit -c unlimited
  $ qemu-system-x86_64 -enable-kvm -m 1024 ...
  ...crash...
  $ gdb -c qemu-system-x86_64.core
  (gdb) bt

Depending on how your system is configured the core file might have a
different filename but there should be a file name *core* the current
working directory after the crash.

The backtrace will make it possible to find out where the crash
occurred.

Thanks,
Stefan
