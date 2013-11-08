Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab3KHQND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:13:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57971 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856Ab3KHQNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:13:01 -0500
Message-ID: <527D0D50.6010607@zytor.com>
Date: Fri, 08 Nov 2013 08:12:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Baoquan He <bhe@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, akpm@linux-foundation.org, davej@fedoraproject.org,
        rmk+kernel@arm.linux.org.uk, chaowang@redhat.com, mwhitehe@redhat.com,
        kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Robin Holt <robinmholt@linux.com>, Robin Holt <robinmholt@gmail.com>
Subject: Re: [PATCH] x86: make reboot task only run on the appropriate processor
References: <1383642967-12595-1-git-send-email-bhe@redhat.com> <20131108151416.GA13068@redhat.com>
In-Reply-To: <20131108151416.GA13068@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 07:14 AM, Vivek Goyal wrote:
> 
> Hi Bao,
> 
> This patch fixes the issue for me too. I noticed that we have generic
> function migrate_to_reboot_cpu() to achieve what we want and rest of
> the reboot paths are using it. So how about using that function. I 
> wrote the new patch below. It works for me. Can you please give it
> a try.
> 
> Thanks
> Vivek
> 

Is this path exercised for the kdump flow?  migrate_to_reboot_cpu() is
unsafe in that case.

> Index: linux-2.6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.orig/kernel/kexec.c	2013-10-16 00:30:50.000000000 -0400
> +++ linux-2.6/kernel/kexec.c	2013-11-08 21:34:02.492072375 -0500
> @@ -1676,6 +1676,7 @@ int kernel_kexec(void)
>  #endif
>  	{
>  		kernel_restart_prepare(NULL);
> +		migrate_to_reboot_cpu();
>  		printk(KERN_EMERG "Starting new kernel\n");
>  		machine_shutdown();
>  	}
> 

