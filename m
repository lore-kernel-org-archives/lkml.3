Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaI3NDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:03:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:30044 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750908AbaI3NDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:03:40 -0400
Date: Tue, 30 Sep 2014 09:03:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Amit Virdi <amitvi128@gmail.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Enabling ftrace on ARM MMU-less system
Message-ID: <20140930090331.15a7b428@gandalf.local.home>
In-Reply-To: <CAEOkp47rz9-V_qZkOGDjfsZQj5bRHq2hf8dghS3xRcwdrP9UzQ@mail.gmail.com>
References: <CAEOkp47rz9-V_qZkOGDjfsZQj5bRHq2hf8dghS3xRcwdrP9UzQ@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014 16:26:49 +0530
Amit Virdi <amitvi128@gmail.com> wrote:

> Hi,
> 
> I'm trying to enable Ftrace on my ARM based MMU-less system.
> Unexpectedly, I don't see tracing directory under /sys/kernel/debug
> I have done the following so far but no success:
> 1. Verified that I have enabled these flags in my .config
>     CONFIG_FUNCTION_TRACER
>     CONFIG_FUNCTION_GRAPH_TRACER
>     CONFIG_STACK_TRACER
>     CONFIG_DYNAMIC_FTRACE
> 
> 2. Enabled Ftrace startup steps. The startup log output is
> ----
>

> Can anyone help what I'm missing or if ftrace is supported on MMU-less
> platforms?

Well it's obviously supported if you see the tests running.

Is there anything else under /sys/kernel/debug? If not you need to
mount the debugfs filesytem there. It wont do it itself.

# mount -t debugfs nodev /sys/kernel/debug

-- Steve
