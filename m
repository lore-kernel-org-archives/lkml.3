Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaANLln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:41:43 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35634 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbaANLli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:41:38 -0500
X-Sasl-enc: dhg78pZopSlcbnFahOL1ZinGkrZqmYBNRgcbe+sicKYQ 1389699697
Date: Tue, 14 Jan 2014 09:41:33 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: AMD errata 793 (CVE-2013-6885) needs a workaround in Linux?
Message-ID: <20140114114133.GA31473@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got this assigned to amd64-microcode in Debian, but it is something
that needs to be worked around by the EFI/BIOS and/or the kernel.

Since we all know just how well it pans out to depend on BIOS/EFI updates
for *anything*, I'm raising the issue here.  IMHO looks like it would be
worthwhile to either set the relevant MSR in the kernel if the BIOS didn't
do it, or at least warn the user of the need for a BIOS/EFI update...

It is the usual hangs-core type of CPU errata (therefore, the best type
since it won't cause silent data corruption).  gcc-produced code managed to
trigger it (in DragonFly BSD).

A quick search under arch/x86 did not locate any existing workaround for
this issue.


Date: Wed, 27 Nov 2013 21:23:37 -0500 (EST)
From: cve-assign@...re.org
To: oss-security@...ts.openwall.com
Cc: cve-assign@...re.org
Subject: CVE-2013-6885 AMD Publ. 51810 Errata 793 system hang

The person who requested CVE-2013-6885 asked that we send the CVE
assignment here because various open-source software will probably be
adding code to prevent this denial of service attack.

http://support.amd.com/TechDocs/51810_16h_00h-0Fh_Rev_Guide.pdf
http://lists.dragonflybsd.org/pipermail/kernel/2011-December/046594.html
http://www.zdnet.com/blog/hardware/amd-owns-up-to-cpu-bug/18924

  793 Specific Combination of Writes to Write Combined Memory
  Types and Locked Instructions May Cause Core Hang

  Under a highly specific and detailed set of internal timing
  conditions, a locked instruction may trigger a timing sequence whereby
  the write to a write combined memory type is not flushed, causing the
  locked instruction to stall indefinitely.

  Potential Effect on System
  Processor core hang.

  Suggested Workaround
  BIOS should set MSRC001_1020[15] = 1b.

  No fix planned

- -- 
CVE assignment team, MITRE CVE Numbering Authority
M/S M300
202 Burlington Road, Bedford, MA 01730 USA

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
