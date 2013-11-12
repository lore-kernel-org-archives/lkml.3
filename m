Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab3KLHT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:19:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:3079 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431Ab3KLHTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:19:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,683,1378882800"; 
   d="scan'208";a="426043943"
Message-ID: <5281D682.4040700@linux.intel.com>
Date: Mon, 11 Nov 2013 23:19:30 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC PATCH 3/3] x86, boot: Change the BIOS corruption checker
 to scan 640K
References: <1384215407-22288-1-git-send-email-hpa@linux.intel.com> <1384215407-22288-4-git-send-email-hpa@linux.intel.com> <20131112040703.GA28410@gmail.com>
In-Reply-To: <20131112040703.GA28410@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 08:07 PM, Ingo Molnar wrote:
> I agree with your patches so far, and I'd suggest we go even further: I'd 
> say the config option is now a misnomer, it should probably be renamed to 
> CONFIG_X86_FORCE_RESERVE_BIOS_LOW_1MB=y or so.

Why is that?  It doesn't seem to make much sense to me.  I think the
current option names seem to be just fine, but perhaps I'm missing
something.

> Btw., should we also force-reserve the remaining bits over 640K..1MB, if 
> they are not marked as reserved in the memory maps, or do we already 
> force-reserve them somewhere?

We do, in trim_bios_range().  We treat it as available for I/O
assignments, since that is necessary on some systems.

> The CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y option and the 
> memory_corruption_check=1 boot option then allow the activation of the low 
> memory corrupion checker - which debug facility can be used on systems 
> where someone wants to live dangerously and not reserve the low 1MB of RAM 
> to the firmware.

That is indeed what this patch does, I think...

	-hpa


