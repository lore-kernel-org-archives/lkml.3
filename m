Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab3FEUON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:14:13 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:26881
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240Ab3FEUOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:14:12 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
X-WSS-ID: 0MNXS7H-01-9UW-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 0/2] x86/microcode/amd: early loading fixes
Date: Wed, 5 Jun 2013 15:13:54 -0500
Message-ID: <1370463236-2115-1-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
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

Jacob Shin (2):
  x86/microcode/amd: make find_ucode_in_initrd() __init
  x86/microcode/amd: allow multiple families' bin files appended
    together

 arch/x86/kernel/microcode_amd_early.c |  148 ++++++++++++++++++++++++---------
 1 file changed, 110 insertions(+), 38 deletions(-)

-- 
1.7.9.5


