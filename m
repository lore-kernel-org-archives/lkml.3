Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3KOO0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:26:32 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39846 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3KOO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:26:25 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [REGRESSION] coredumps truncated after "new helper: dump_align()"
Date: Fri, 15 Nov 2013 15:26:10 +0100
Message-ID: <11835033.kIc1RH0rS1@al>
User-Agent: KMail/4.11.3 (Linux/3.12.0-1-custom; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Somewhere in the merge window of 3.13, coredumps appear truncated.
Instead of 319488 bytes, I get 868 bytes (tested with x86_64 only).

The latest Linus' master (v3.12-9579-g049ffa8) is still affected.
Bisection leads to:

commit 22a8cb8248ba5d340307ba72432253b1dbdb5cf7
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Oct 8 11:05:01 2013 -0400

    new helper: dump_align()
    
    dump_skip to given alignment...
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

:040000 040000 880920de653955485453c8cc11045bb09e2934f7 f8b348d32b59ae7a16cbc3eb2a6319f4df0210eb M      arch
:040000 040000 eaeffe2378806e95d23b3f3a9dc0fa8f078d6052 88866abde93296a05b4adda869280bc05403936f M      fs
:040000 040000 218263e01dd7473998c54a5a68ed5ae072854d24 ff531dce919862b662fef19a9a049f0de3db38ce M      include

I first noticed this bug on my laptop (v3.12-7033-g42a2d92) and
reproduced this bug in a QEMU virtual machine too. If you want, I
can also provide the git bisect script that starts QEMU and tests
the serial output. That allows a kernel to be verified in two seconds
(minus build times).

Regards,
Peter
