Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaFPNIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:08:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39167 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaFPNIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:08:02 -0400
Date: Mon, 16 Jun 2014 15:07:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jan-Simon =?utf-8?Q?M=C3=B6ller?= <dl9pf@gmx.de>
Cc: Behan Webster <behanw@converseincode.com>,
        Mark Charlebois <mcharleb@gmail.com>, PaX Team <pageexec@freemail.hu>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: 3d3d6b847420 ("kbuild: LLVMLinux: Adapt warnings for compilation
 with clang")
Message-ID: <20140616130751.GD8170@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the commit in $Subject breaks the purpose of the W= build to see
additional warnings.

With it, currently I get all that stuff disabled with gcc:

$ make V=1 W=1  fs/direct-io.o

...

gcc -Wp,-MD,... -Wno-sign-compare -Wno-missing-field-initializers
-Wno-unused-value -Wno-format -Wno-sign-compare -Wno-format-zero-length
-Wno-uninitialized ...

which is clearly wrong. If I'm building with W=1, I *explicitly* *want*
those additional warnings enabled, not disabled.

Please fix this to have effect only for clang but not for the rest of
the universe.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
