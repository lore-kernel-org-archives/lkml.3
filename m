Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaBGQ1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:27:55 -0500
Received: from mail2.elkosia.lv ([85.15.200.133]:58037 "EHLO mail2.elkosia.lv"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750775AbaBGQ1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:27:54 -0500
X-Copfilter: Client is part of local network, skipped Spamassassin
Message-ID: <17469.87.110.183.114.1391790471.squirrel@www.silodev.com>
In-Reply-To: <11414.87.110.183.114.1391682066.squirrel@www.silodev.com>
References: <11414.87.110.183.114.1391682066.squirrel@www.silodev.com>
Date: Fri, 7 Feb 2014 18:27:51 +0200 (EET)
Subject: Re: Max number of posix queues in vanilla kernel       
     (/proc/sys/fs/mqueue/queues_max)
From: m@silodev.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Copfilter-Originating-IP: 192.168.18.15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Any comments or concerns about this?

many thanks,
Madars

> Hi Folks,
>
> I have recently ported my multi-process application (like a classical open
> system) which uses POSIX Queues as IPC to one of the latest Linux kernels,
> and I have faced issue that number of maximum queues are dramatically
> limited down to 1024 (see include/linux/ipc_namespace.h, #define
> HARD_QUEUESMAX 1024).
>
> Previously the max number of queues was INT_MAX (on 64bit system was:
> 2147483647).
>
> This update imposes bad limits on our multi-process application. As our
> app uses approaches that each process opens its own set of queues (usually
> something about 3-5 queues per process). In some scenarios we might run up
> to 3000 processes or more (which of-course for linux is not a problem).
> Thus we might need up to 9000 queues or more. All processes run under one
> user.
>
> But now we have this limit, which limits our software down and we are
> getting in trouble. We could patch the kernel manually, but not all
> customers are capable of this and willing to do the patching.
>
> Thus I *kindly* ask you guys to increase this limit to something like 1M
> queues or more (or to technical limit i.e. leave the same INT_MAX). If
> user can screw up the system by setting or using maximums, let it leave to
> the user. As it is doing system tuning and he is responsible for kernel
> parameters.
>
> The kernel limit was introduced by:
> -
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=93e6f119c0ce8a1bba6e81dc8dd97d67be360844
>
> Also I see other people are claiming issues with this, see:
> - https://bugs.launchpad.net/ubuntu/+source/manpages/+bug/1155695 - for
> them some database software is not working after the kernel upgrade...
>
> Also I think that when people will upgrade from RHEL 5 or RHEL 6 to next
> versions where this hard limit will be defined, I suspect that many will
> claim problem about it...
>
> Thanks a lot in advance,
> Madars Vitolins
>
>
>


