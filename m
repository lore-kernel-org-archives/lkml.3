Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaBDMsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:48:30 -0500
Received: from mail.eperm.de ([89.247.134.16]:38170 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbaBDMs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:48:29 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: [RFC PATCH 0/5] CPU Jitter RNG
Date: Tue, 04 Feb 2014 13:36:59 +0100
Message-ID: <2039634.jSmQAS6tdi@myon.chronox.de>
User-Agent: KMail/4.11.5 (Linux/3.12.8-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with the previous release of the CPU Jitter RNG ([1]), concerns were raised on 
the presence of entropy in the CPU execution timing. With this new version of 
the CPU Jitter RNG, a new noise source based on memory access timings is now 
added and the concerns raised before are addressed with additional analyses 
given in [2] section 6.1.

This additional noise source is again covered with extensive testing 
documented in [2] section 6.2. The test results allowed the explanation of the 
basics of that memory access noise source.

To analyze the two noise sources, a bare metal testing program is used as 
documented in [2] section 6.3. That bare metal testing allows the analysis of 
the noise source without interference of an OS and interrupts.

Furthermore, for the already existent noise source of the CPU execution 
timing, more analysis of the behavior of the CPU is provided in [2] section 
6.1. The analysis, however, showed CPU behavior that cannot easily be 
explained. The testing shows that there is a possibility to eliminate the CPU 
execution timing jitter for one particular measurement using a serialization 
instruction. That elimination of timing jitter, however, was not visible when 
the individual rounds of the RNG were tested. That means that the elimination 
of timing jitter in one special case did not show any effects on the behavior 
of the RNG.

The following set of patches integrate the CPU Jitter RNG as a fallback noise 
source into /dev/random. The reason for using it as a fallback only is the 
conceptual difference of the CPU Jitter RNG to the other noise sources: all 
other noise sources are a push mechanism whereas the CPU Jitter RNG works by 
pulling bits on demand. Due to the speed of the Jitter RNG, it has the 
capability of monopolizing all other noise sources which is prevented by only 
invoking it when the lower entropy threshold of the Linux RNG is reached.

Ciao
Stephan 

[1] http://thread.gmane.org/gmane.linux.kernel/1577419/focus=1586212
[2] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html
-- 
| Cui bono? |
