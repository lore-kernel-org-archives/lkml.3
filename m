Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935812Ab3DKJaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:30:07 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38996 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935532Ab3DKJaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:30:03 -0400
Date: Thu, 11 Apr 2013 11:29:58 +0200
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
Cc: "Huangweidong (C)" <weidong.huang@huawei.com>,
        kvm list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Luonengjun <luonengjun@huawei.com>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zanghongyong <zanghongyong@huawei.com>,
        Zhanghuanzhong <zhanghuanzhong@huawei.com>, corentin.chary@gmail.com,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [Qemu-devel] reply: reply: qemu crashed when starting vm(kvm)
 with vnc connect
Message-ID: <20130411092958.GF8904@stefanha-thinkpad.redhat.com>
References: <D3E216785288A145B7BC975F83A2ED103FE154C1@szxeml556-mbx.china.huawei.com>
 <20130405063456.GA27569@stefanha-thinkpad.redhat.com>
 <D3E216785288A145B7BC975F83A2ED103FE16528@szxeml556-mbx.china.huawei.com>
 <20130408105052.GC12076@stefanha-thinkpad.redhat.com>
 <D3E216785288A145B7BC975F83A2ED103FE16749@szxeml556-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D3E216785288A145B7BC975F83A2ED103FE16749@szxeml556-mbx.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 12:27:06PM +0000, Zhanghaoyu (A) wrote:
> On Sun, Apr 07, 2013 at 04:58:07AM +0000, Zhanghaoyu (A) wrote:
> > >>> I start a kvm VM with vnc(using the zrle protocol) connect, sometimes qemu program crashed during starting period, received signal SIGABRT.
> > >>> Trying about 20 times, this crash may be reproduced.
> > >>> I guess the cause memory corruption or double free.
> > >>
> > >> Which version of QEMU are you running?
> > >> 
> > >> Please try qemu.git/master.
> > >> 
> > >> Stefan
> > >
> > >I used the QEMU download from qemu.git (http://git.qemu.org/git/qemu.git).
> >
> > Great, thanks!  Can you please post a backtrace?
> > 
> > The easiest way is:
> > 
> >  $ ulimit -c unlimited
> >  $ qemu-system-x86_64 -enable-kvm -m 1024 ...
> >  ...crash...
> >  $ gdb -c qemu-system-x86_64.core
> >  (gdb) bt
> > 
> > Depending on how your system is configured the core file might have a different filename but there should be a file name *core* the current working directory
> after the crash.
> > 
> > The backtrace will make it possible to find out where the crash occurred.
> > 
> > Thanks,
> > Stefan
> 
> backtrace from core file is shown as below:
> 
> Program received signal SIGABRT, Aborted.
> 0x00007f32eda3dd95 in raise () from /lib64/libc.so.6
> (gdb) bt
> #0  0x00007f32eda3dd95 in raise () from /lib64/libc.so.6
> #1  0x00007f32eda3f2ab in abort () from /lib64/libc.so.6
> #2  0x00007f32eda77ece in __libc_message () from /lib64/libc.so.6
> #3  0x00007f32eda7dc06 in malloc_printerr () from /lib64/libc.so.6
> #4  0x00007f32eda7ecda in _int_free () from /lib64/libc.so.6
> #5  0x00007f32efd3452c in free_and_trace (mem=0x7f3290000cd0) at vl.c:2880
> #6  0x00007f32efd251a1 in buffer_free (buffer=0x7f32f0c82890) at ui/vnc.c:505
> #7  0x00007f32efd20c56 in vnc_zrle_clear (vs=0x7f32f0c762d0)
>     at ui/vnc-enc-zrle.c:364
> #8  0x00007f32efd26d07 in vnc_disconnect_finish (vs=0x7f32f0c762d0)
>     at ui/vnc.c:1050
> #9  0x00007f32efd275c5 in vnc_client_read (opaque=0x7f32f0c762d0)
>     at ui/vnc.c:1349
> #10 0x00007f32efcb397c in qemu_iohandler_poll (readfds=0x7f32f074d020,
>     writefds=0x7f32f074d0a0, xfds=0x7f32f074d120, ret=1) at iohandler.c:124
> #11 0x00007f32efcb46e8 in main_loop_wait (nonblocking=0) at main-loop.c:417
> #12 0x00007f32efd31159 in main_loop () at vl.c:2133
> #13 0x00007f32efd38070 in main (argc=46, argv=0x7fff7f5df178,
>     envp=0x7fff7f5df2f0) at vl.c:4481

CCing Corentin and Gerd who are more familiar with the VNC code than me.

Stefan
