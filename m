Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3F0Stp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:49:45 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:47430
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593Ab3F0Stn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:49:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1b0bIzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dhbe9i1155h)
From: Stehle Vincent-B46079 <B46079@freescale.com>
To: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: next-20130627 breaks i.MX6 sabre sd UART console
Thread-Topic: next-20130627 breaks i.MX6 sabre sd UART console
Thread-Index: Ac5zZxBZeupdDlSIRDWI6ggVo3oJ5Q==
Date: Thu, 27 Jun 2013 18:49:36 +0000
Message-ID: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.137.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

FYI I remark that today's Linux next 'next-20130627' breaks i.MX6 sabre sd UART console with ARM config imx_v6_v7_defconfig.

This was working fine yesterday with 'next-20130626'.

Bisecting gave me this commit:

  064706514ec3fea740c2656e03c4f01f6a551ac4  clocksource: Add generic dummy timer driver

If I revert it I do indeed get the boot messages on the UART console again, but the kernel then crashes in wm8962_probe(). So there is more to find out...

Best regards,

V.


