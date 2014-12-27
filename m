Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaL0NsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 08:48:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaL0NsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 08:48:01 -0500
Message-ID: <549EB88D.20403@suse.com>
Date: Sat, 27 Dec 2014 14:47:57 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?KOI8-R?Q?=F0=CC=C1=CD=C5=CE_=F0=C5=D4=D2=CF=D7?= 
	<plamen@petrovi.no-ip.info>,
        linux-kernel@vger.kernel.org
CC: "'Thomas Gleixner'" <tglx@linutronix.de>
Subject: Re: [BISECTED] 3.19-rc1 regression - kernel does not load in GRUB
 0.97 (GRUB Legacy)
References: <000001d01f10$85f506f0$91df14d0$@petrovi.no-ip.info>
In-Reply-To: <000001d01f10$85f506f0$91df14d0$@petrovi.no-ip.info>
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2014 01:28 AM, Пламен Петров wrote:
> Hello!
>
> I use GRUB Legacy bootloader (version 0.97) on a couple machines, and where
> 3.18.x loads fine, 3.19-rc1 does not.
>
> While compiling I used the attached .config file accompanied by "make
> olddefconfig"

Can you tell me something about the hardware (processor model)?
You are not booting the system under VMWare by any chance?

Could you try the earlyprintk kernel option (serial or vga)?

Can you boot with kernel option "nopat"?


Juergen

>
> The bisection I ran points to:
> bd809af16e3ab1f8d55b3e2928c47c67e2a865d2 is the first bad commit
> commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
> Author: Juergen Gross <jgross@suse.com>
> Date:   Mon Nov 3 14:02:03 2014 +0100
>
>      x86: Enable PAT to use cache mode translation tables
>
>      Update the translation tables from cache mode to pgprot values
>      according to the PAT settings. This enables changing the cache
>      attributes of a PAT index in just one place without having to change
>      at the users side.
>
>      With this change it is possible to use the same kernel with different
>      PAT configurations, e.g. supporting Xen.
>
> Here is the output of git bisect log
>
> git bisect start
> # bad: [97bf6af1f928216fd6c5a66e8a57bfa95a659672] Linux 3.19-rc1
> git bisect bad 97bf6af1f928216fd6c5a66e8a57bfa95a659672
> # good: [b2776bf7149bddd1f4161f14f79520f17fc1d71d] Linux 3.18
> git bisect good b2776bf7149bddd1f4161f14f79520f17fc1d71d
> # bad: [70e71ca0af244f48a5dcf56dc435243792e3a495] Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
> git bisect bad 70e71ca0af244f48a5dcf56dc435243792e3a495
> # bad: [e28870f9b3e92cd3570925089c6bb789c2603bc4] Merge tag
> 'backlight-for-linus-3.19' of
> git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight
> git bisect bad e28870f9b3e92cd3570925089c6bb789c2603bc4
> # good: [6da314122ddc11936c6f054753bbb956a499d020] Merge tag 'dt-for-linus'
> of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect good 6da314122ddc11936c6f054753bbb956a499d020
> # good: [a53b831549141aa060a8b54b76e3a42870d74cc0] exit: pidns: fix/update
> the comments in zap_pid_ns_processes()
> git bisect good a53b831549141aa060a8b54b76e3a42870d74cc0
> # bad: [cbfe0de303a55ed96d8831c2d5f56f8131cd6612] Merge branch 'for-linus'
> of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> git bisect bad cbfe0de303a55ed96d8831c2d5f56f8131cd6612
> # bad: [a6b849578ef3e0b131b1ea4063473a4f935a65e9] Merge branch 'for-linus'
> of git://git.samba.org/sfrench/cifs-2.6
> git bisect bad a6b849578ef3e0b131b1ea4063473a4f935a65e9
> # bad: [c9f861c77269bc9950c16c6404a9476062241671] Merge branch
> 'x86-ras-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect bad c9f861c77269bc9950c16c6404a9476062241671
> # good: [773fed910d41e443e495a6bfa9ab1c2b7b13e012] Merge branches
> 'x86-platform-for-linus' and 'x86-uv-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 773fed910d41e443e495a6bfa9ab1c2b7b13e012
> # good: [f439c429c320981943f8b64b2a4049d946cb492b] x86: Support PAT bit in
> pagetable dump for lower levels
> git bisect good f439c429c320981943f8b64b2a4049d946cb492b
> # good: [e3480271f59253cb60d030aa5e615bf00b731fea] x86, mce, severity:
> Extend the the mce_severity mechanism to handle UCNA/DEFERRED error
> git bisect good e3480271f59253cb60d030aa5e615bf00b731fea
> # bad: [0dbcae884779fdf7e2239a97ac7488877f0693d9] x86: mm: Move PAT only
> functions to mm/pat.c
> git bisect bad 0dbcae884779fdf7e2239a97ac7488877f0693d9
> # bad: [bd809af16e3ab1f8d55b3e2928c47c67e2a865d2] x86: Enable PAT to use
> cache mode translation tables
> git bisect bad bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
> # good: [f5b2831d654167d77da8afbef4d2584897b12d0c] x86: Respect PAT bit when
> copying pte values between large and normal pages
> git bisect good f5b2831d654167d77da8afbef4d2584897b12d0c
> # first bad commit: [bd809af16e3ab1f8d55b3e2928c47c67e2a865d2] x86: Enable
> PAT to use cache mode translation tables
>
> Reverting the above commit fixes the problem for me, and 3.19-rc1 loads
> fine.
>
> Any additional info available on request.
>
> Please, CC me - I am not subscribed to the list.
> ---------------------------------
> Plamen Petrov
>

