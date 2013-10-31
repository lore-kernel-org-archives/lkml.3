Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3JaQ1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:27:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40299 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab3JaQ1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:27:15 -0400
Date: Thu, 31 Oct 2013 17:27:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: sysfs: cannot create duplicate filename /bus/i2c/drivers/tps65010
Message-ID: <20131031162706.GF10544@pd.tnic>
References: <20131031152343.GE10544@pd.tnic>
 <20131031161352.GA9587@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131031161352.GA9587@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 09:13:52AM -0700, Lee Jones wrote:
> > just FYI: I see the below with the attached randconfig on latest -rc7+
> > (output is a bit funny due to keeping earlyprintk on).
> > 
> > [    0.460026] ------------[ cut here ]------------
> > [    0.462726] WARNING: CPU: 0 PID: 1 at fs/sysfs/dir.c:526 sysfs_add_one+0xa0/0xc0()
> > [    0.464002] sysfs: cannot create duplicate filename '/bus/i2c/drivers/tps65010'
> > [    0.466018] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-rc7-02023-gf5889fb1b3ba #1
> > [    0.468002]  0000000000000009
> > [    0.468002]  0000000000000009 ffff88007e44fc20 ffff88007e44fc20 ffffffff89cda7e4 ffffffff89cda7e4 ffff88007e44fc58 ffff88007e44fc58
> > [    0.470111]  ffffffff89089307
> > [    0.470111]  ffffffff89089307 00000000ffffffef 00000000ffffffef ffff88007e52cd20 ffff88007e52cd20 ffff88007e44fd00 ffff88007e44fd00
> > [    0.473348]  ffff88007e549000
> > [    0.473348]  ffff88007e549000 0000000000000000 0000000000000000 ffff88007e44fcb8 ffff88007e44fcb8 ffffffff890893a7 ffffffff890893a7
> > [    0.475453] Call Trace:
> > [    0.476004]  [<ffffffff89cda7e4>] dump_stack+0x19/0x1b
> > [    0.477448]  [<ffffffff89089307>] warn_slowpath_common+0x67/0x90
> > [    0.479108]  [<ffffffff890893a7>] warn_slowpath_fmt+0x47/0x50
> > [    0.480003]  [<ffffffff89198ea0>] sysfs_add_one+0xa0/0xc0
> > [    0.481493]  [<ffffffff8919900f>] create_dir+0x6f/0xe0
> > [    0.482910]  [<ffffffff89199394>] sysfs_create_dir+0x84/0xe0
> > [    0.484011]  [<ffffffff8941dd7f>] kobject_add_internal+0xaf/0x2c0
> > [    0.485690]  [<ffffffff8941dff0>] kobject_init_and_add+0x60/0x80
> > [    0.488010]  [<ffffffff8943ee2d>] ? __raw_spin_lock_init+0x2d/0x50
> > [    0.489721]  [<ffffffff895774ae>] bus_add_driver+0x9e/0x2a0
> > [    0.492017]  [<ffffffff8a769b5d>] ? wm831x_spi_init+0x28/0x28
> > [    0.493622]  [<ffffffff8957914f>] driver_register+0x5f/0xf0
> > [    0.495160]  [<ffffffff8a769b5d>] ? wm831x_spi_init+0x28/0x28
> > [    0.496018]  [<ffffffff89845c67>] i2c_register_driver+0x27/0xb0
> > [    0.497650]  [<ffffffff8a769b91>] tps_init+0x34/0x79
> > [    0.499041]  [<ffffffff8a743df3>] do_one_initcall+0x7c/0x117
> > [    0.500011]  [<ffffffff890a62d8>] ? parse_args+0x1f8/0x330
> > [    0.501522]  [<ffffffff8a743fa1>] kernel_init_freeable+0x113/0x198
> > [    0.504002]  [<ffffffff8a74382f>] ? do_early_param+0x88/0x88
> > [    0.505587]  [<ffffffff89cc9990>] ? rest_init+0x130/0x130
> > [    0.507079]  [<ffffffff89cc9999>] kernel_init+0x9/0x180
> > [    0.508004]  [<ffffffff89ced98a>] ret_from_fork+0x7a/0xb0
> > [    0.509496]  [<ffffffff89cc9990>] ? rest_init+0x130/0x130
> > [    0.512011] ---[ end trace 70292a51052b5aeb ]---
> 
> Is this an MFD issue?

I'd think so because AFAICT it all starts from
drivers/mfd/tps65010.c::tps_init() but I don't know the code so ...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
