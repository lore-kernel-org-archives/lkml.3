Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaHKTaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:30:09 -0400
Received: from david.siemens.de ([192.35.17.14]:56637 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbaHKTaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:30:07 -0400
Message-ID: <53E919AF.1090607@siemens.com>
Date: Mon, 11 Aug 2014 21:29:51 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: HPET as CPU-local timer + interrupt remapping = lockup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

just noticed an apparent regression of x86-64 on CPUs without ARAT but a
sufficient number if HPET timers: If you have interrupt remapping
enabled, the kernel will lock up during boot, apparently waiting for
some never-arriving interrupts.

I'm currently adding VT-d interrupt emulation to QEMU and stumbled over
this behavior. It didn't turn out to be an emulation issue, I just
reproduced on real hardware (ARAT patched out) and found some old 3.0
kernel booting fine inside my QEMU version.

FWIW, some further details I found out under QEMU: the HPET timers do
not seem to be switched to MSI mode yet when the lockup happens.

I suppose the issue is uncritical as the combination of hardware feature
(or their absence) is probably untypical, correct? I can't invest much
into bisecting or debugging right now unfortunately. But maybe someone
has an idea what could case this.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
