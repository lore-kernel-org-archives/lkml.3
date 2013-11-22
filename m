Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3KVLs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 06:48:26 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:45261 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3KVLsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 06:48:25 -0500
Date: Fri, 22 Nov 2013 12:48:19 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [BUG] 3ce1217d6cd5 ima patch causes s390 to crash on boot
Message-ID: <20131122114819.GB4208@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112211-8372-0000-0000-000007DA1B75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roberto,

your patch 3ce1217d6cd5 "ima: define template fields library and new helpers"
causes s390 to crash on boot:

 IMA: No TPM chip found, activating TPM-bypass!
 Unable to handle kernel pointer dereference at virtual kernel address 0000000000842000
 Oops: 0004 [#1] SMP
 Modules linked in:
 CPU: 3 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc2-00098-g3ce1217d6cd5 #17
 task: 000000003ffa0000 ti: 000000003ff84000 task.ti: 000000003ff84000
 Krnl PSW : 0704e00180000000 000000000044bf88 (strsep+0x7c/0xa0)
            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 EA:3
 Krnl GPRS: 000000000000007c 000000000000007c 000000003ff87d90 0000000000821fd8
            0000000000000000 000000000000007c 0000000000aa37e0 0000000000aa9008
            0000000000000051 0000000000a114d8 0000000100000002 0000000000842bde
            0000000000842bdf 00000000006f97f0 000000000040062c 000000003ff87cf0
 Krnl Code: 000000000044bf7c: a7f4000a           brc     15,44bf90
            000000000044bf80: b90200cc           ltgr    %r12,%r12
           #000000000044bf84: a7840006           brc     8,44bf90
           >000000000044bf88: 9200c000           mvi     0(%r12),0
            000000000044bf8c: 41c0c001           la      %r12,1(%r12)
            000000000044bf90: e3c020000024       stg     %r12,0(%r2)
            000000000044bf96: b904002b           lgr     %r2,%r11
            000000000044bf9a: ebbcf0700004       lmg     %r11,%r12,112(%r15)
 Call Trace:
 ([<00000000004005fe>] ima_init_template+0xa2/0x1bc)
  [<0000000000a7c896>] ima_init+0x7a/0xa8
  [<0000000000a7c938>] init_ima+0x24/0x40
  [<00000000001000e8>] do_one_initcall+0x68/0x128
  [<0000000000a4eb56>] kernel_init_freeable+0x20a/0x2b4
  [<00000000006a1ff4>] kernel_init+0x30/0x178
  [<00000000006b69fe>] kernel_thread_starter+0x6/0xc
  [<00000000006b69f8>] kernel_thread_starter+0x0/0xc
 Last Breaking-Event-Address:
  [<000000000044bf42>] strsep+0x36/0xa0

