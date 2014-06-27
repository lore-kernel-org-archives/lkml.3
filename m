Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaF0TRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:17:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:34894 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751570AbaF0TRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:17:20 -0400
Date: Fri, 27 Jun 2014 15:17:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 2/2] trace-cmd: [BUGFIX] Don't die if an instance does
 not have 'current_tracer' file
Message-ID: <20140627151718.22f22685@gandalf.local.home>
In-Reply-To: <20140624022345.14037.44275.stgit@yuno-kbuild.novalocal>
References: <20140624022340.14037.63549.stgit@yuno-kbuild.novalocal>
	<20140624022345.14037.44275.stgit@yuno-kbuild.novalocal>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014 02:23:45 +0000
Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:

> Current trace-cmd requires 'current_tracer' file for an instance, and if
> the file is nothing, trace-cmd dies. However, current_tracer file was
> introduced from 607e2ea167e patch in Linux kernel 3.14-rc3, so current
> trace-cmd cannot use multiple buffers for old kernels.
> 
> This patch avoids to die if current_tracer file is nothing in an instance
> and the plugin name is "nop". This is because old kernels always trace
> as nop mode in an instance.
> 
> <How to test>
> 1) # ./trace-cmd record -B foo -e sched
> 
> Before introducing this patch, following error message is output in an old
> kernel:
> 
>  trace-cmd: Permission denied
>    writing to '/sys/kernel/debug/tracing/instances/foo/current_tracer'
> 
> trace-cmd dies in disable_trace() calling set_plugin("nop").
> After introducing this patch, trace-cmd works fine in both old kernels and
> current kernel.
> 
> 2) # ./trace-cmd record -B foo -e sched -p nop
> 
> It also works fine after introducing this patch in both old kernels and current
> kernel.
> 
> 3) # ./trace-cmd record -B foo -e sched -p function
> 
> For old kernels, it dies because an user should not set plugin tracer.
> For current kernel, it works fine.
> 
> Note that this patch was tested for kernel 3.11.9-200 and 3.15.0-rc2+.
> 
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Applied, thanks!

-- Steve
