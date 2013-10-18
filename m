Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3JRQW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:22:26 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47199 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3JRQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <20131018082236.GA25694@ulmo.nvidia.com>
References: <20131018003847.GH2443@sirena.org.uk>
	<20131018074526.GA30578@quad.lixom.net>
	<20131018082236.GA25694@ulmo.nvidia.com>
Date: Fri, 18 Oct 2013 09:22:23 -0700
Message-ID: <CAGa+x85fVXitWiOcRcMWRsPZ-D7tqinbTazDAtww3+JWtJzpCQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Oct 17
From: Kevin Hilman <khilman@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 1:22 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Fri, Oct 18, 2013 at 12:45:26AM -0700, Olof Johansson wrote:
>> On Fri, Oct 18, 2013 at 01:38:47AM +0100, Mark Brown wrote:
>> > Hi all,
>> >
>> > I've uploaded today's linux-next tree to the master branch of the
>> > repository below:
>> >
>> >         git://gitorious.org/thierryreding/linux-next.git >
>> > A next-20131017 tag is also provided for convenience.
>> >
>> > One new conflict today but otherwise uneventful.  x86_64 allmodconfigs
>> > build after each merge but no other build tests were done.
>>
>> Hi,
>>
>> I'm seeing a fairly large fallout on boot testing. See
>> http://lists.linaro.org/pipermail/kernel-build-reports/2013-October/000719.html
>> for full list (I need to start providing longer backlogs for failures, the top
>> of the oopses is lost in the email).
>>
>> For example, on dove (SolidRun Cubox) I see:
>>
>> [    0.707248] Unable to handle kernel NULL pointer dereference at virtual address 00000054
>> [    0.715297] pgd = c0004000
>> [    0.717984] [00000054] *pgd=00000000
>> [    0.721548] Internal error: Oops: 5 [#1] ARM
>> [    0.725794] Modules linked in:
>> [    0.728841] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc5-next-20131017 #1
>> [    0.736114] task: ef035c00 ti: ef036000 task.ti: ef036000
>> [    0.741497] PC is at kfree+0x54/0xc4
>> [    0.745063] LR is at ata_host_register+0x3c/0x290
>> [    0.749741] pc : [<c008ad28>]    lr : [<c023e168>]    psr: 40000193
>> [    0.749741] sp : ef037da8  ip : 00000034  fp : 00000000
>> [    0.761159] r10: 00000000  r9 : ef061810  r8 : c0519fc8
>> [    0.766353] r7 : c0519fc8  r6 : a0000113  r5 : ffffffff  r4 : ef1c9dd0
>> [    0.772850] r3 : c0fc8fe0  r2 : c07c9000  r1 : 40000000  r0 : 00000000
>> [    0.779349] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
>> [    0.786708] Control: 10c5387d  Table: 00004019  DAC: 00000015
>> [    0.792428] Process swapper (pid: 1, stack limit = 0xef036248)
>> [    0.798234] Stack: (0xef037da8 to 0xef038000)
>> [    0.957218] [<c008ad28>] (kfree+0x54/0xc4) from [<c023e168>] (ata_host_register+0x3c/0x290)
>> [    0.965542] [<c023e168>] (ata_host_register+0x3c/0x290) from [<c023e498>] (ata_host_activate+0xdc/0x118)
>> [    0.974992] [<c023e498>] (ata_host_activate+0xdc/0x118) from [<c0251130>] (mv_platform_probe+0x2dc/0x36c)
>> [    0.984527] [<c0251130>] (mv_platform_probe+0x2dc/0x36c) from [<c021b6c4>] (platform_drv_probe+0x18/0x48)
>> [    0.994051] [<c021b6c4>] (platform_drv_probe+0x18/0x48) from [<c0219e88>] (really_probe+0x74/0x1fc)
>> [    1.003062] [<c0219e88>] (really_probe+0x74/0x1fc) from [<c021a0fc>] (__driver_attach+0x98/0x9c)
>> [    1.011804] [<c021a0fc>] (__driver_attach+0x98/0x9c) from [<c02186cc>] (bus_for_each_dev+0x60/0x94)
>> [    1.020808] [<c02186cc>] (bus_for_each_dev+0x60/0x94) from [<c0219728>] (bus_add_driver+0x148/0x1f0)
>> [    1.029898] [<c0219728>] (bus_add_driver+0x148/0x1f0) from [<c021a700>] (driver_register+0x78/0xf8)
>> [    1.038911] [<c021a700>] (driver_register+0x78/0xf8) from [<c04e2ed0>] (mv_init+0x30/0x50)
>> [    1.047144] [<c04e2ed0>] (mv_init+0x30/0x50) from [<c000877c>] (do_one_initcall+0x100/0x14c)
>> [    1.055557] [<c000877c>] (do_one_initcall+0x100/0x14c) from [<c04cead4>] (kernel_init_freeable+0x120/0x1c0)
>> [    1.065259] [<c04cead4>] (kernel_init_freeable+0x120/0x1c0) from [<c038fe30>] (kernel_init+0x8/0x158)
>> [    1.074441] [<c038fe30>] (kernel_init+0x8/0x158) from [<c000e0b8>] (ret_from_fork+0x14/0x3c)
>> [    1.082841] Code: e0823283 e3110902 1593301c e593001c (e5904054)
>>
>>
>> I bisected it down to commit 55acc602faae7c10e53acdca0c70f4936c2539c6, which
>> is really weird. That is:
>>
>> commit 55acc602faae7c10e53acdca0c70f4936c2539c6
>> Merge: e32face ba6857b
>> Author:     Mark Brown <broonie@linaro.org>
>> AuthorDate: Thu Oct 17 23:55:55 2013 +0100
>> Commit:     Mark Brown <broonie@linaro.org>
>> CommitDate: Thu Oct 17 23:55:55 2013 +0100
>>
>>     Merge remote-tracking branch 'driver-core/driver-core-next'
>>
>>     Conflicts:
>>         include/linux/netdevice.h
>>
>>
>> But there isn't anything controversial in the merge commit.
>>
>> I tried checking out either side of that merge, and they both boot
>> fine. I redid the merge myself, and I get no delta compared to your
>> merge and I still get the same failure.
>>
>> I've got more failures than dove, I'll try bisecting a few of the others
>> in the morning (it's late here), hopefully they will help indicate what's
>> actually going wrong. I'm guessing something just happens to move around
>> enough to expose a different problem once the two branches are merged.
>
> Looking at that oops it seems like host is actually NULL when kfree() is
> called in ata_host_register(). That seems to only happen when freeing up
> any of the unused ports, which is strange in itself because Cubox seems
> to only register a single one. Also if host is indeed NULL, then things
> should go haywire much sooner.
>
> Looks like you won't easily find out what's going on here unless you get
> into it somewhat deeper and perhaps trace what exactly fails and why the
> NULL pointer is even there in the first place.

For me, bisect has fingered the patch below[1].  Reverting that gets
i.MX6 wandboard and snowball booting again.  Looking into the details
about why now...

Kevin

[1]
$ git log -n1 bisect/bad
commit 64c862a839a8db2c02bbaa88b923d13e1208919d
Author: Joe Perches <joe@perches.com>
Date:   Fri Oct 11 13:11:38 2013 -0700

    devres: add kernel standard devm_k.alloc functions

    Currently, devm_ managed memory only supports kzalloc.

    Convert the devm_kzalloc implementation to devm_kmalloc and remove the
    complete memset to 0 but still set the initial struct devres header and
    whatever padding before data to 0.

    Add the other normal alloc variants as static inlines with __GFP_ZERO
    added to the gfp flag where appropriate:

    devm_kzalloc
    devm_kcalloc
    devm_kmalloc_array

    Add gfp.h to device.h for the newly added static inlines.

    akpm: the current API forces us to replace kmalloc() with kzalloc() when
    performing devm_ conversions.  This adds a relatively minor overhead.
    More significantly, it will defeat kmemcheck used-uninitialized checking,
    and for a particular driver, losing used-uninitialised checking for their
    core controlling data structures will significantly degrade kmemcheck
    usefulness.

    Signed-off-by: Joe Perches <joe@perches.com>
    Cc: Tejun Heo <tj@kernel.org>
    Cc: Sangjung Woo <sangjung.woo@samsung.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
