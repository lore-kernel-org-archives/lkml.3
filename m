Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaCaKiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:38:22 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:34550
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953AbaCaKiT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:38:19 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh109h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh1155h)
X-WSS-ID: 0N3AQVO-08-2LG-02
X-M-MSG: 
From: "Skidanov, Alexey" <Alexey.Skidanov@amd.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Gabbay, Oded" <Oded.Gabbay@amd.com>
Subject: CONFIG_PREEMPT_COUNT
Thread-Topic: CONFIG_PREEMPT_COUNT
Thread-Index: Ac9MzRkbuCbbxoUOSeu2AxrjYz5GfQ==
Date: Mon, 31 Mar 2014 10:38:12 +0000
Message-ID: <AD975D71AAD7784D8D1265DF6444C2FD0132AD51@storexdag03.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.0.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I found that preempt_enable() and preempt_disable() macros are defined differently depending on CONFIG_PREEMPT_COUNT:
- They increment per CPU preemption counter, if CONFIG_PREEMPT_COUNT defined
- They do nothing (just call barrier), if not.
I have it undefined in my source tree.

The questions are:
1. What is the purpose of CONFIG_PREEMPT_COUNT define and how I can define it?
2. In the previous kernel versions, spin_lock() and spin_unlock() call preempt_enable() and preempt_disable() respectively, ensuring that the current task will not be preempted by any other task while lock is held. Is this still ensured with these macros defined as "do nothing" ?

Thanks
Alexey

