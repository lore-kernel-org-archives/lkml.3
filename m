Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaLOFRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 00:17:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaLOFRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 00:17:32 -0500
Message-ID: <548E6EEA.2070900@suse.com>
Date: Mon, 15 Dec 2014 06:17:30 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: jongman.heo@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [3.18+] Can't boot with commit bd809af1 ("x86: Enable PAT to
 use cache mode translation tables")
References: <1983011076.75441418533626741.JavaMail.weblogic@epmlwas09c>
In-Reply-To: <1983011076.75441418533626741.JavaMail.weblogic@epmlwas09c>
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2014 06:07 AM, ÇãÁ¾¸¸ wrote:
> 
> Hi,
> 
> My Linux virtual machine on (Windows) VMWare workstation 10 can't boot with following commit.
> 
> commit bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
> Author: Juergen Gross <jgross@suse.com>
> Date:   Mon Nov 3 14:02:03 2014 +0100
> 
>      x86: Enable PAT to use cache mode translation tables
> 
> Unfortunately I can't see any console log.

Hmm, weird. Could you provide some more information?

Kernel config, hardware used, /proc/cpuinfo of working kernel?
Anything you see with earlyprintk enabled?


Juergen

> Reverting the commit fixes my boot issue. git bisect log follows,
> 
> $ git bisect log
> git bisect start
> # bad: [92a578b064d0227a3a7fbbdb9e29dbab7f8d400e] Merge tag 'pm+acpi-3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect bad 92a578b064d0227a3a7fbbdb9e29dbab7f8d400e
> # good: [b2776bf7149bddd1f4161f14f79520f17fc1d71d] Linux 3.18
> git bisect good b2776bf7149bddd1f4161f14f79520f17fc1d71d
> # good: [6da314122ddc11936c6f054753bbb956a499d020] Merge tag 'dt-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect good 6da314122ddc11936c6f054753bbb956a499d020
> # good: [482a3767e5087f6e6ad2486a6655aaa5f3d59301] exit: reparent: call forget_original_parent() under tasklist_lock
> git bisect good 482a3767e5087f6e6ad2486a6655aaa5f3d59301
> # bad: [cbfe0de303a55ed96d8831c2d5f56f8131cd6612] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> git bisect bad cbfe0de303a55ed96d8831c2d5f56f8131cd6612
> # bad: [a6b849578ef3e0b131b1ea4063473a4f935a65e9] Merge branch 'for-linus' of git://git.samba.org/sfrench/cifs-2.6
> git bisect bad a6b849578ef3e0b131b1ea4063473a4f935a65e9
> # bad: [c9f861c77269bc9950c16c6404a9476062241671] Merge branch 'x86-ras-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect bad c9f861c77269bc9950c16c6404a9476062241671
> # good: [773fed910d41e443e495a6bfa9ab1c2b7b13e012] Merge branches 'x86-platform-for-linus' and 'x86-uv-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 773fed910d41e443e495a6bfa9ab1c2b7b13e012
> # good: [773fed910d41e443e495a6bfa9ab1c2b7b13e012] Merge branches 'x86-platform-for-linus' and 'x86-uv-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 773fed910d41e443e495a6bfa9ab1c2b7b13e012
> # good: [f439c429c320981943f8b64b2a4049d946cb492b] x86: Support PAT bit in pagetable dump for lower levels
> git bisect good f439c429c320981943f8b64b2a4049d946cb492b
> # good: [e3480271f59253cb60d030aa5e615bf00b731fea] x86, mce, severity: Extend the the mce_severity mechanism to handle UCNA/DEFERRED error
> git bisect good e3480271f59253cb60d030aa5e615bf00b731fea
> # bad: [0dbcae884779fdf7e2239a97ac7488877f0693d9] x86: mm: Move PAT only functions to mm/pat.c
> git bisect bad 0dbcae884779fdf7e2239a97ac7488877f0693d9
> # bad: [bd809af16e3ab1f8d55b3e2928c47c67e2a865d2] x86: Enable PAT to use cache mode translation tables
> git bisect bad bd809af16e3ab1f8d55b3e2928c47c67e2a865d2
> # good: [f5b2831d654167d77da8afbef4d2584897b12d0c] x86: Respect PAT bit when copying pte values between large and normal pages
> git bisect good f5b2831d654167d77da8afbef4d2584897b12d0c
> # first bad commit: [bd809af16e3ab1f8d55b3e2928c47c67e2a865d2] x86: Enable PAT to use cache mode translation tables
> 

