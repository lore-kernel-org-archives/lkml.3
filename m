Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3EHJcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 05:32:14 -0400
Received: from outgoing.email.vodafone.de ([139.7.28.128]:57918 "EHLO
	outgoing.email.vodafone.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104Ab3EHJcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 05:32:12 -0400
X-Authentication-Info: Sender authenticated as deathsimple@vodafone.de (using CRAM-MD5)
Message-ID: <518A1B94.6090001@vodafone.de>
Date: Wed, 08 May 2013 11:32:04 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] radeon: Allow disabling UVD
References: <CAOULuOb79h99RiyYpMGLzzM2QeawYfG8CfrvNtk4WtJJxRn87g@mail.gmail.com> <1367910123.12136.7.camel@thor.local> <5188BEF7.7090505@vodafone.de> <CAOULuObffavZs9+p-C_C5Y6y=6aJhnYVf_d0nXWXb9Zt2A7rBw@mail.gmail.com>
In-Reply-To: <CAOULuObffavZs9+p-C_C5Y6y=6aJhnYVf_d0nXWXb9Zt2A7rBw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.05.2013 23:13, schrieb Parag Warudkar:
> On Tue, May 7, 2013 at 4:44 AM, Christian König <deathsimple@vodafone.de> wrote:
>
>> The patch shouldn't be necessary because just removing the firmware should
>> have pretty much the same effect.
> Soon distros will ship the UVD firmware by default and then users will
> need to manually remove it and then do the same with every update.
> Besides, I just discovered that when UVD is enabled suspend resume
> breaks  - tried 3 times with SUMO_uvd loaded - machine suspends but
> resumes instantly.
> Without SUMO_uvd.bin - suspends fine and only wakes up when I want it to.

Hui? Wait a second, the firmware doesn't work but still causes an 
instant resume on suspend? Very strange.

>> The only case where we indeed seems to have a problem are Macs with
>> integrated cards, and we can always just blacklist those if the problem
>> doesn't seems to be solvable.
> I happen to have the problematic card in my iMac - I'd be glad to
> provide any info or try any patches. Just let me know.
> For now I will remove the firmware - I reboot /suspend-resume often
> and it is a bit annoying to have to go through those mdelays only to
> fail.

Yeah, perfectly understandable.

My best guess is that it has something todo with a different clock 
routing on Macs, but without access to the hardware (or precise 
documentation from Apple what the heck they did different) I don't 
really see a chance to solve that problem.

If you want to hack a bit on it you could try commenting out the calls 
to "radeon_set_uvd_clocks" in radeon_uvd.c. That should give you the 
default clocks of 100Mhz, not enough for usable decoding, but on SUMO 
based UVD blocks a very failsafe default.

Whatever it is, please send me an output of lspci, so I can blacklist 
the offending chip.

Christian.

> Thanks,
> Parag
>

