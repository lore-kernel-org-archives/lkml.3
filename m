Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaDDJJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 05:09:51 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:44760 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaDDJJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 05:09:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAES_P+8kwWhaFoJPvvbDh6rJ0+VTpFutqUGefZmbghN21XtVdw@mail.gmail.com>
References: <CAES_P+8kwWhaFoJPvvbDh6rJ0+VTpFutqUGefZmbghN21XtVdw@mail.gmail.com>
Date: Fri, 4 Apr 2014 17:09:45 +0800
Message-ID: <CALZhoST1BDtFo63aU2obkh=gXx=ORctSXrvkKip4Vm6qzy8pvw@mail.gmail.com>
Subject: Re: Query for time tracking between userspace and kernelspace
From: Lei Wen <adrian.wenl@gmail.com>
To: noman pouigt <variksla@gmail.com>
Cc: john.stultz@linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Joe Perches <joe@perches.com>, Petr Mladek <pmladek@suse.cz>,
        linux-kernel@vger.kernel.org, leiwen@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 3:02 PM, noman pouigt <variksla@gmail.com> wrote:
> Hello,
>
> Probably this question belongs to kernelnewbies
> list but I think i will get accurate answer from here.
>
> I am doing some optimization in kernel video driver
> code to reduce the latency from the time buffer
> is given to the time it is displayed.
>
> Userspace:
> t1 = gettimeofday()
>
> Kernelspace:
> t2 = do_gettimeofday()
>
> Using debugfs i am copying t2 to userspace and
> subtracting the result.
>
> latency = t2 - t1
>
> Would this be accurate? I know there is context
> switch involved and other stuff but this is the method
> i came up with. Any better way?
>

Not sure whether it is accurate or not...
But from the code, gettimeofday syscall define in kernel/time.c
is also using the kernel's do_gettimeofday API, and then copy to
userspace, which shall not so different with your debugfs usage.

For better way, would this vDSO getimeofday could fulfill your need?
You may refer to: https://lwn.net/Articles/585203/

Thanks,
Lei
