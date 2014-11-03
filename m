Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaKCTif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 14:38:35 -0500
Received: from www.linutronix.de ([62.245.132.108]:55136 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaKCTie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 14:38:34 -0500
Date: Mon, 3 Nov 2014 20:38:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel J Blueman <daniel@numascale.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH v3 5/5] Use 2GB memory block size on large x86-64
 systems
In-Reply-To: <1414915813-2462-5-git-send-email-daniel@numascale.com>
Message-ID: <alpine.DEB.2.11.1411032021331.5308@nanos>
References: <1414915813-2462-1-git-send-email-daniel@numascale.com> <1414915813-2462-5-git-send-email-daniel@numascale.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Nov 2014, Daniel J Blueman wrote:

> On larger x64-64 systems, use a 2GB memory block size to reduce sysfs
> entry creation time by 16x. Large is defined as 64GB or more memory.

This changelog sucks.

It neither tells which sysfs entries are meant nor does it explain
what the actual effect of this change is aside of speeding up some
random sysfs thingy.

> @@ -1247,9 +1246,9 @@ static unsigned long probe_memory_block_size(void)
>  	/* start from 2g */
>  	unsigned long bz = 1UL<<31;
>  
> -#ifdef CONFIG_X86_UV
> -	if (is_uv_system()) {
> -		printk(KERN_INFO "UV: memory block size 2GB\n");
> +#ifdef CONFIG_X86_64

And this brainless 's/CONFIG_X86_UV/CONFIG_X86_64/' sucks even
more. I'm sure you can figure out the WHY yourself.

> +	if (totalram_pages >= (64ULL << (30 - PAGE_SHIFT))) {
> +		pr_info("Using 2GB memory block size for large-memory system\n");
>  		return 2UL * 1024 * 1024 * 1024;
>  	}
>  #endif

Thanks,

	tglx

 
