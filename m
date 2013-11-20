Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3KTM01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 07:26:27 -0500
Received: from vistrem1.vector-informatik.com ([217.89.139.138]:55629 "EHLO
	vistrem1.vector-informatik.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962Ab3KTM00 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 07:26:26 -0500
From: "Frederich, Jens" <Jens.Frederich@vector.com>
To: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Kernel Panic] 3.10.10-rt7
Thread-Topic: [Kernel Panic] 3.10.10-rt7
Thread-Index: Ac7l66BMdAdPuzbGTZONTbGkPOT5yw==
Date: Wed, 20 Nov 2013 12:26:22 +0000
Message-ID: <9B7F15AA4177464A8FAB5BE79B14288B88967CEF@vistrex3.vi.vector.int>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.49.46.146]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I got a Kernel panic by some long time stress tests. Look here: http://dy.cx/pqP7M.

Furthermore I got sporadic some BUG messages:

[ 1128.358971] BUG: scheduling while atomic: swapper/0/0/0x00010002
[ 1128.358982] Preemption disabled at:[<ffffffff810dfb8a>] cpu_startup_entry+0x17a/0x300

Hardware
--------

My system is a i7 with 4 GB RAM congatec evalboard.

Setup
-----

On the system runs Linux RT (text mode) 3.10.10-rt7 with 1 GB RAM and a
Windows 7 KVM/QEMU (Qemu 1.6.1) guest with 3 GB RAM. Each system has it own
ethernet card. The Win 7 guest uses it per pci pass-through. The Win 7 is
pinned to core 2,3.

Scenario
--------

We sending UDP packages every 1 msec on the Linux side. The UDP sender process
has real time prio 80 and the ethernet driver 90. At the same time we are
stressing Win 7. Memory stress - allocate as much as possible and do memset(),
then CPU stress - high CPU load, then Kernel DPC stress - high load thread at
DPC level and ethernet stress - send UDP packages every milliseconds. I got the
panic after 45 minutes. It seems that is correlates with the ethernet stress.

Can anybody help me?

thanks
Jens



