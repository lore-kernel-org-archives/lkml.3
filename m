Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3BVAEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 19:04:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab3BVAEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 19:04:50 -0500
Message-ID: <5126B617.6010405@canonical.com>
Date: Thu, 21 Feb 2013 19:04:39 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tanaka Takahisa <mc74hc00@gmail.com>
CC: Joseph Salisbury <josephtsalisbury@gmail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Subject: Re: [v3.8 Regression] watchdog: sp5100_tco: Add SB8x0 chipset support
References: <511D0BCC.9070208@canonical.com> <20130215073210.GM7867@spo001.leaseweb.com> <511E4C43.7080403@canonical.com> <CAHh0gOgeWn5QaDGzgstft7AoQsKdoZ+4Utp8iQxxSCO0q=cZ-Q@mail.gmail.com> <51219C56.8060504@canonical.com> <CAGHUO12ROdB4=LVyod7+RaoONHfMfiyLAj73cC+BczLGDG+i+Q@mail.gmail.com> <CAHh0gOgiSjTYvEzim-7+yEhU74c5PVV=2ScTnaJ15SPY=y-WqA@mail.gmail.com>
In-Reply-To: <CAHh0gOgiSjTYvEzim-7+yEhU74c5PVV=2ScTnaJ15SPY=y-WqA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 12:14 PM, Tanaka Takahisa wrote:
> Hi Joseph,
>
> Thanks a lot for your help.
>
>> The bug report tested a kernel with the patches. However, he reports the kernel panic still occurs[0].
> I understood. I guess this problem conflicts with the watchdog MMIO
> address (*) written in SB700 chipset and other resource. So, I made a
> patch which gets rid of the code considered to cause the problem. If
> this patch is applied, although the SP5100 and SB7x0 chipsets can't
> use watchdog function any longer, I'm sure attached patch resolve the
> problem. The SB800 or later chipsets can be used as before.
> (*)This address is obtained from allocate_resource() function.
>
> I'm sorry to trouble you, but Would you confirm whether attached patch
> solves a problem?
> If there is no problem in this patch, I will submit this patch to a
> linux-watchdog community.

This patch did resolve the issue.  The bug reporter states the panic no 
longer happens and the system boots.  Thanks so much for your assistance.

>
>
>> I've requested a digital image or screen capture of the panic.  Is
>> there any additional debug information you thing would be helpful?
> I'm interested in the I/O resource of PC in which the problem has
> occurred, So, I want the result of 'cat /proc/iomem'. When 'cat
> /proc/iomem' is performed, I don't care about whether sp5100_tco
> driver is loaded.

The I/O data can be seen at:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1116835/+attachment/3540738/+files/iomem.txt

>
>
> Thanks in advance.
> Takahisa

