Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaDNMyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:54:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbaDNMyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:54:03 -0400
Date: Mon, 14 Apr 2014 14:53:59 +0200
From: Jean Delvare <jdelvare@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Michal Marek <mmarek@suse.cz>
Subject: Hardware dependencies in Kconfig
Message-ID: <20140414145359.48b7337c@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Configuring kernels from scratch has become an incredibly long and
tedious task. The reason is that the number of drivers and options has
exploded in the past few years. Which in itself is great - Linux is
successful, yeah! - but the side effects must be dealt with.
6000-line .config files are no fun.

Earlier today, I found that NET_CADENCE is set in my x86-64 kernel
configuration. The two ethernet drivers below this menu are for ARM
machines. I really shouldn't be asked about that on x86-64. I just sent
a patch addressing this specific issue, which follows about 50 similar
patches from me for similar issues in various subsystems. But I can't
do all of that by myself, this is too much work quantitatively, and I
am not always the best person to find out the proper hardware
dependencies that should be added.

I would like to call for proper hardware dependencies to become a
general trend: every new hardware-specific driver which is added to the
kernel should depend on ($hardware || COMPILE_TEST), so as to make it
clear right away, which type of hardware is expected to need the driver
in question.

$hardware can be the top-level architecture (e.g. ARM), but can also go
down to sub-architecture/platform (e.g. ARCH_AT91 or PLATFORM_AT32AP) or
even machine (e.g. PICOXCELL_PC3X3). The list can always be extended
later if needed. Ideally we should restrict as much as possible as long
as the result is easy to maintain, not too complex, and not likely to
break in a near future.

Thanks to COMPILE_TEST, we don't lose the build test coverage, and it
also makes it possible for anyone to still build the driver if the
dependency is too strict (as a temporary workaround until it gets fixed
upstream, that is.)

Does anyone object to this?

Ideally existing drivers would get the same treatment, and I encourage
subsystem maintainers or architecture maintainers to check which of
"their" drivers would benefit from that. But I understand this will take
some time, and this is certainly harder for existing drivers as a risk
of regression exists if we set too strict dependencies.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
