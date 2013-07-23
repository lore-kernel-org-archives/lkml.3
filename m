Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106Ab3GWUUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:20:11 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:38007 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934219Ab3GWUUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:20:06 -0400
Date: Tue, 23 Jul 2013 22:20:03 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: Andrew Veliath <andrewtv@usa.net>, linux-kbuild@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.11-rc2
In-Reply-To: <alpine.DEB.2.02.1307232209510.32497@ayla.of.borg>
Message-ID: <alpine.DEB.2.02.1307232210440.32577@ayla.of.borg>
References: <alpine.DEB.2.02.1307232209510.32497@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.11-rc2 to v3.11-rc1[3], the summaries are:
>   - build errors: +9/-23

Ignoring a few new R_PPC64_REL24 truncated relocations, we have:

  + error: No rule to make target /etc/sound/msndinit.bin:  => N/A
  + error: No rule to make target /etc/sound/msndperm.bin:  => N/A
  + error: No rule to make target /etc/sound/pndsperm.bin:  => N/A
  + error: No rule to make target /etc/sound/pndspini.bin:  => N/A

i386-randconfig, due to an OSS sound issue:

make[3]: *** No rule to make target `/etc/sound/msndperm.bin', needed by `sound/oss/msndperm.c'.
make[3]: *** No rule to make target `/etc/sound/msndinit.bin', needed by `sound/oss/msndinit.c'.
make[3]: *** No rule to make target `/etc/sound/pndsperm.bin', needed by `sound/oss/pndsperm.c'.
make[3]: *** No rule to make target `/etc/sound/pndspini.bin', needed by `sound/oss/pndspini.c'.

  + error: No rule to make target include/config/auto.conf:  => N/A

powerpc-randconfig, due to a kconfig issue:

Expose SCOM controllers via debugfs (SCOM_DEBUGFS) [N/y] (NEW) aborted!
Console input/output is redirected. Run 'make oldconfig' to update configuration
.
make[3]: *** [silentoldconfig] Error 1

  + error: sh_mobile_sdhi.c: undefined reference to `shdma_chan_filter':  => .text+0x124658)

sh-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/6461/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6435/ (all 120 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
