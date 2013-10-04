Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3JDNZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:25:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:53863 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3JDNY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:24:59 -0400
Date: Fri, 4 Oct 2013 15:24:58 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ilw <ilw@linux.intel.com>, linux-rt-users@vger.kernel.org
Subject: Re: 3.10.10-rt7: inconsistent lock state (iwlwifi)
Message-ID: <20131004132458.GG19953@linutronix.de>
References: <1379365850.3828.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1379365850.3828.3.camel@localhost.localdomain>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Meyer | 2013-09-16 23:10:50 [+0200]:

>Hi,
Hi Thomas,

>lockdep complains about this:
>
>[   92.041513] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
>[   92.090910] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
>
>[   92.094779] =================================
>[   92.094780] [ INFO: inconsistent lock state ]
>[   92.094782] 3.10.10-rt7 #5 Not tainted
>[   92.094783] ---------------------------------
>[   92.094784] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
>[   92.094787] systemd-journal/1002 [HC1[1]:SC0[0]:HE0:SE1] takes:
>[   92.094801]  (&trans_pcie->irq_lock){?.+...}, at: [<ffffffffa015587c>] iwl_pcie_isr_ict+0x2c/0x2d0 [iwlwifi]
>[   92.094802] {HARDIRQ-ON-W} state was registered at:

I posted a patch earlier regarding iwl. Can you please check if this
cures this problem, too?

Sebastian
