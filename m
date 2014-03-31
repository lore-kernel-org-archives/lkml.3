Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaCaMuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:50:40 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:47984
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbaCaMuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:50:39 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz98dI9371Ic89bh936eI542I328cMzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2dh109h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
X-WSS-ID: 0N3AX06-08-7ZY-02
X-M-MSG: 
From: "Skidanov, Alexey" <Alexey.Skidanov@amd.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: CONFIG_PREEMPT_COUNT
Thread-Topic: CONFIG_PREEMPT_COUNT
Thread-Index: Ac9MzRkbuCbbxoUOSeu2AxrjYz5GfQAMKgqAAAfdxOA=
Date: Mon, 31 Mar 2014 12:50:30 +0000
Message-ID: <AD975D71AAD7784D8D1265DF6444C2FD0132AD98@storexdag03.amd.com>
References: <AD975D71AAD7784D8D1265DF6444C2FD0132AD51@storexdag03.amd.com>
 <1396268697.2110.15.camel@x220>
In-Reply-To: <1396268697.2110.15.camel@x220>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.0.144]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2VCojsi026418

Paul,
Thank you for your answer. We have PREEMT_VOLUNTARY  defined, so that is the reason why the CONFIG_PREEMPT_COUNT is undefined. 
The second question (that was badly formatted in original message) was:

In the previous kernel versions, spin_lock() and spin_unlock() call preempt_enable() and preempt_disable() respectively,
ensuring that the current task will not be preempted by any other task while lock is held. Is this still ensured with these macros defined as â€œdo nothingâ€ ?

-----Original Message-----
From: Paul Bolle [mailto:pebolle@tiscali.nl] 
Sent: Monday, March 31, 2014 3:25 PM
To: Skidanov, Alexey
Cc: linux-kernel@vger.kernel.org; Gabbay, Oded
Subject: Re: CONFIG_PREEMPT_COUNT

Alexey,

On Mon, 2014-03-31 at 10:38 +0000, Skidanov, Alexey wrote:
> What is the purpose of CONFIG_PREEMPT_COUNT define and how I can 
> define it?

CONFIG_PREEMPT_COUNT is a Kconfig macro, ie it's (in short) to be defined as a result one of the "*config" make targets. And doing
    git grep -nw PREEMPT_COUNT

gives
    kernel/Kconfig.preempt:38:      select PREEMPT_COUNT
    kernel/Kconfig.preempt:57:config PREEMPT_COUNT
    lib/Kconfig.debug:964:  select PREEMPT_COUNT

And looking at those hits it seems PREEMPT_COUNT will be set, and therefore CONFIG_PREEMPT_COUNT defined, if either PREEMPT or DEBUG_ATOMIC_SLEEP are set in a .config.

(I'm not familiar with PREEMPT_COUNT. I think I never used it.)

Hope this helps,


Paul Bolle


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
