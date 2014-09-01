Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaIAKUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 06:20:10 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38574 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752974AbaIAKUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 06:20:07 -0400
Date: Mon, 1 Sep 2014 11:19:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wang Long <long.wanglong@huawei.com>
Cc: santosh.shilimkar@ti.com, victor.kamensky@linaro.org, nico@linaro.org,
        ben.dooks@codethink.co.uk, cov@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [SMP BUG?] the return value of is_smp() is bug?
Message-ID: <20140901101952.GF30401@n2100.arm.linux.org.uk>
References: <1409571334-2814-1-git-send-email-long.wanglong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409571334-2814-1-git-send-email-long.wanglong@huawei.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, do not send multiple copies of your message to mailing lists,
certainly not within the three hours that you sent your three copies.
If one of the addresses you sent the message to bounces, then it is
*only* that one recipient who doesn't get your message, everyone else
receives a copy.  So, there's now three copies of your message in the
list archives, and people could end up replying to different messages.

On Mon, Sep 01, 2014 at 07:35:34PM +0800, Wang Long wrote:
> Hi,all
> 
> In kernel 3.17-rc2, when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y 
> in .config file. the secondary core can not boot.
> 
> when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = n in .config file,
> the secondary core can boot.
> 
> But this does not happen in kernel 3.10 lts kernel, Whether the 
> CONFIG_SMP_ON_UP is set yes or no ,the secondary core can boot.
> 
> Does the meaning of CONFIG_SMP_ON_UP changed or this is a bug in kernel 3.17-rc2 ? 

I think the answer is neither, because when the kernel is run on /real/
hardware:

http://www.arm.linux.org.uk/developer/build/result.php?type=boot&idx=2514

it boots fine, bringing up all four CPUs.

> config:     set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y
> command:    # qemu-system-arm -M vexpress-a9 -smp 2  -m 128M -kernel arch/arm/boot/zImage -nographic

I've no idea how qemu works here, but if the CPU doesn't indicate that
it's a SMP capable CPU, we will disable SMP extensions.

> The output:
> 
> ..........
> is_smp() return false;
> CPU: Testing write buffer coherency: ok
> missing device node for CPU 0
> CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
> Setting up static identity map for 0x604643d8 - 0x60464430
> Brought up 1 CPUs
> SMP: Total of 1 processors activated.
> CPU: All CPU(s) started in SVC mode.
> ...........

You have decided that you'll edit the kernel messages, removing at least
some of the information that could be relevant to the issue.  Please,
only cut kernel messages when you are absolutely certain that they are
not relevant to the problem you're reporting.

However, I don't think it would help much - I suspect that qemu doesn't
provide emulation of the SCU base address register, and that's what your
problem is.  qemu needs to be fixed in that regard.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
