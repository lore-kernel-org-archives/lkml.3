Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3KKVhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:37:55 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50631 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3KKVhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:37:48 -0500
MIME-Version: 1.0
In-Reply-To: <20131111170558.GA12741@gmail.com>
References: <20131111170558.GA12741@gmail.com>
Date: Mon, 11 Nov 2013 13:37:48 -0800
X-Google-Sender-Auth: yRel9rWi_bH-r5WgcE9QQWsAVjQ
Message-ID: <CAE9FiQWrzZB+wpSXGeQTPKi2o7MKvONFkk0_POe-E+wco07Erw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/boot changes for v3.13
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 9:05 AM, Ingo Molnar <mingo@kernel.org> wrote:

> Two changes that prettify and compactify the SMP bootup output from:
>
>  [    0.371169] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
>  [    0.417339] smpboot: Booting Node   1, Processors  #4 #5 #6 #7 OK
>  [    0.554805] smpboot: Booting Node   2, Processors  #8 #9 #10 #11 OK
>  [    0.692323] smpboot: Booting Node   3, Processors  #12 #13 #14 #15 OK
>  [    0.829039] Brought up 16 CPUs
>
> to something like:
>
> [    0.379167] x86: Booting SMP configuration:
> [    0.383506] .... node  #0, CPUs:        #1  #2  #3
> [    0.429207] .... node  #1, CPUs:    #4  #5  #6  #7
> [    0.565353] .... node  #2, CPUs:    #8  #9 #10 #11
> [    0.701898] .... node  #3, CPUs:   #12 #13 #14 #15
> [    0.837695] x86: Booted up 4 nodes, 16 CPUs
>
...
>         if (system_state == SYSTEM_BOOTING) {
>                 if (node != current_node) {
>                         if (current_node > (-1))
> -                               pr_cont(" OK\n");
> +                               pr_cont("\n");
>                         current_node = node;
> -                       pr_info("Booting Node %3d, Processors ", node);
> +
> +                       printk(KERN_INFO ".... node %*s#%d, CPUs:  ",
> +                              node_width - num_digits(node), " ", node);
>                 }
> -               pr_cont(" #%4d%s", cpu, cpu == max_cpu_present ? " OK\n" : "");
> -               return;
> +
> +               /* Add padding for the BSP */
> +               if (cpu == 1)
> +                       pr_cont("%*s", width + 1, " ");

How do you know CPU0 and CPU1 are in same package?

> +
> +               pr_cont("%*s#%d", width - num_digits(cpu), " ", cpu);
> +
>         } else
>                 pr_info("Booting Node %d Processor %d APIC 0x%x\n",
>                         node, cpu, apicid);
