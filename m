Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab3FHChl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 22:37:41 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:51008
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930Ab3FHChk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 22:37:40 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jun 2013 22:37:40 EDT
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
X-WSS-ID: 0MO1YLA-01-6JZ-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@alien8.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V3 0/2] x86/microcode/amd: early loading fixes
Date: Fri, 7 Jun 2013 21:22:18 -0500
Message-ID: <1370658140-5299-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset addreses two problems with early loading on AMD.

First, feedback from Yinghai that find_ucode_in_initrd() should be
marked __init:
  https://lkml.org/lkml/2013/6/4/695

And second, feedback from Henrique that Intel early loading supports
multiple microcode firmware concatenated together, whereas the current
AMD implementation lacks this support:
  https://lkml.org/lkml/2013/5/31/4

V3:
* style fix -- reduce multiple if statements into a single one

V2:
* test for !initrd_start before using it
* use __pa() instead of __pa_nodebug() on AP load
* fixed calculation of start offset and size of the microcode container file

Jacob Shin (2):
  x86/microcode/amd: make find_ucode_in_initrd() __init
  x86/microcode/amd: allow multiple families' bin files appended
    together

 arch/x86/kernel/microcode_amd_early.c |  170 ++++++++++++++++++++++++---------
 1 file changed, 125 insertions(+), 45 deletions(-)

-- 
1.7.9.5


