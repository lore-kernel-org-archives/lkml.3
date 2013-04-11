Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3DKEqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 00:46:11 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54304 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3DKEqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 00:46:09 -0400
MIME-Version: 1.0
In-Reply-To: <51658B1A.6090706@wwwdotorg.org>
References: <CAFNq8R5FFUyH+JgjoGc5ctgEfiLvxzi7fzawM7+wFX5nEyTv-w@mail.gmail.com>
	<51658B1A.6090706@wwwdotorg.org>
Date: Thu, 11 Apr 2013 12:46:07 +0800
Message-ID: <CAFNq8R6mRJRygfnYvZgwVWOqsrhrjNUYzyZGU0cVsnE30W_xGg@mail.gmail.com>
Subject: Re: Kexec couldn't reboot capture kernel on pandaboard ES with OMAP4460
From: Li Haifeng <omycle@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: pandaboard@googlegroups.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/10 Stephen Warren <swarren@wwwdotorg.org>:
> On 04/10/2013 03:35 AM, Li Haifeng wrote:
>> Hi, everyone.
>>
>> Recently, I try to run kdump on pandaboard ES with omap4460. After
>> load capture kernel by "kexec -l" and execute "kexec -e", the serial
>> port output "Starting new kernel" and "Bye", then the system hangs up.
>>
>> I have tried the upstream Linux Kernel v3.4 and v3.8. All are with this issue.
>
> This is a shot in the dark. I assume you have SMP enabled. Can you use
> hotplug to remove all CPUs other than CPU0, so that the kexec happens on
> the boot CPU? That is certainly necessary for kexec to work correctly on
> Tegra.

Thanks for your attention.

I do disable SMP feature. And the .config file for v3.8 could be found here:
http://pastehtml.com/view/cylyrfejt.txt

The log and operation could be found here:
http://pastehtml.com/view/cylyfrb3a.txt

Some key setting list below.

bootargs:
rw vram=32M fixrtc mem=1G@0x80000000 root=/dev/mmcblk0p2
console=ttyO2,115200n8 rootwait crashkernel=64M@0x82000000

operation:
/ # ./kexec -l  --append="rw vram=32M fixrtc  root=/dev/mmcblk0p2 console=ttyO2,
115200n8 rootwait" uImage
/ # ./kexec -d -e

The output:
[   57.373687] Starting new kernel
[   57.377044] Bye!

Then system hangs.
