Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab3GBHSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 03:18:17 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:33157
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932219Ab3GBHSO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 03:18:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Stehle Vincent-B46079 <B46079@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@codeaurora.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: RE: next-20130627 breaks i.MX6 sabre sd UART console
Thread-Topic: next-20130627 breaks i.MX6 sabre sd UART console
Thread-Index: Ac5zZxBZeupdDlSIRDWI6ggVo3oJ5QAkUYcAAAf2xwAAAZFOUAAA2+yAABLhygAAdGeRAAAHHZgAAACKafAACWuggAAENQ6AAADXUgAAFuhZwA==
Date: Tue, 2 Jul 2013 07:18:10 +0000
Message-ID: <F7C43F8B2814514CA05F3436BC68046EF33576@039-SN2MPN1-011.039d.mgd.msft.net>
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de>
 <51CDB26A.9060500@codeaurora.org>
 <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
 <51CDC2B3.1030907@codeaurora.org> <20130629020738.GG11625@codeaurora.org>
 <F7C43F8B2814514CA05F3436BC68046EF2EF29@039-SN2MPN1-011.039d.mgd.msft.net>
 <alpine.DEB.2.02.1307011425500.4013@ionos.tec.linutronix.de>
 <F7C43F8B2814514CA05F3436BC68046EF2F708@039-SN2MPN1-011.039d.mgd.msft.net>
 <alpine.DEB.2.02.1307011531210.4013@ionos.tec.linutronix.de>
 <51D1DD6D.8050805@codeaurora.org>
 <alpine.DEB.2.02.1307012153060.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307012153060.4013@ionos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.137.192]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
(..)
> So we need two fixes:
> 
> 1) The replacement of the dummy timer and the effect on the broadcast
>    mask/device
> 
> 2) tick_check_oneshot_broadcast needs a sanity check
> 
> Patch below.

Hi,

Thank you for your patch Thomas; I think it works :)

With your patch, next-20130702 boots pretty far on i.MX6 sabre sd, until it crashes in wm8962_probe(). Without this patch, I don't even get the first kernel messages. (Both with ARM config imx_v6_v7_defconfig.)

Also, I am pretty sure the wm8962_probe() issue is unrelated, as it happened even before this timer thing.

Thank you!

Best regards,

V.


