Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3APPVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:21:07 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36427 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3APPVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:21:01 -0500
Subject: Re: what is the function of do_softirq() ?
From: anish kumar <anish198519851985@gmail.com>
To: Anuz Pratap Singh Tomar <chambilkethakur@gmail.com>
Cc: horseriver <horserivers@gmail.com>, kernelnewbies@kernelnewbies.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAJnfX5u1UJQCLpM2w92TbB+qHmB5TNdDigj+pebrJKN2EUQ7OA@mail.gmail.com>
References: <20130115063105.GA18830@debian.localdomain>
	 <CAJnfX5u1UJQCLpM2w92TbB+qHmB5TNdDigj+pebrJKN2EUQ7OA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jan 2013 20:50:40 +0530
Message-ID: <1358349640.1591.30.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 10:25 +0000, Anuz Pratap Singh Tomar wrote:
> 
> 
> On Tue, Jan 15, 2013 at 6:31 AM, horseriver <horserivers@gmail.com>
> wrote:
>         hi:
>         
>            what is the function of do_softirq()?
Softirq is basically same as bottom half except it is run in irq
context.So the question which comes to mind is why softirq?Softirqs can
run concurrently on several CPUs and that is why it used in networking.
There are other advantages also but it is mostly use case dependent.
>         
>            It is called by ksoftirqd() ,which is setup by :
>         kernel_thread(ksoftirqd, hcpu, CLONE_KERNEL) ; 
ksoftirq is a saviour thread which takes up the execution of softirq if
it finds out that softirq are executing one by one and thereby userspace
is not being scheduled or none of other task is getting executed.As
threads have low priority it lets other tasks run.
>         
> Please read "Understanding the Linux Kernel" Chapter on Interrupts and
> Section on Softirqs and tasklets.  Page number 171(might be different
> in other editions) onwards.
> 
> 
> 
>         thanks!
>         
>         _______________________________________________
>         Kernelnewbies mailing list
>         Kernelnewbies@kernelnewbies.org
>         http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
> 
> 
> 
> -- 
> Thank you 
> Warm Regards
> Anuz
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies


