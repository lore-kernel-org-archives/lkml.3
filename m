Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaBGXRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 18:17:34 -0500
Received: from mail-pd0-f194.google.com ([209.85.192.194]:37167 "EHLO
	mail-pd0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaBGXRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 18:17:32 -0500
Date: Fri, 7 Feb 2014 15:17:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Commit 34b9c07a3 (microblaze: Disable stack protection from
 bootloader) causing qemu crash
Message-ID: <20140207231731.GA8647@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

commit 34b9c07a3 (microblaze: Disable stack protection from bootloader) results
in the following qemu crash in 3.14-rc1.

/opt/buildbot/bin/qemu-system-microblaze -M petalogix-s3adsp1800 -kernel arch/microblaze/boot/linux.bin -no-reboot -append "console=ttyUL0,115200 " -nographic
qemu: fatal: fetching nop sequence

IN: PC=20
rmsr=4300 resr=7 rear=c0389fe8 debug=0 imm=ffffffd0 iflags=0 fsr=0
btaken=1 btarget=c03a9f24 mode=kernel(saved=kernel) eip=512 ie=0
r00=00000000 r01=c0389fcc r02=c0386a52 r03=000000c0
r04=00004100 r05=9052fab4 r06=00000000 r07=90530ab4
r08=00000000 r09=00400000 r10=00400000 r11=c03a9f24
r12=00621000 r13=40aef0c0 r14=00000000 r15=c0000294
r16=00000000 r17=c03a9f28 r18=00000000 r19=00000000
r20=00000000 r21=00000000 r22=00000000 r23=00000000
r24=00000000 r25=00000000 r26=00000000 r27=00000000
r28=00000000 r29=00400000 r30=00000300 r31=c03932d4


Aborted (core dumped)

I have seen this with qemu 1.6.0 and 1.7.0.

Reverting the patch solves the problem.

Is this a qemu bug, a bug in the code, or a bug in my configuration ?
Any idea what I can do about it ?

Thanks,
Guenter
