Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3ENIds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 04:33:48 -0400
Received: from mx0.aculab.com ([213.249.233.131]:54647 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756592Ab3ENIdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 04:33:45 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCHv2 net 1/2] sfc: Delete EFX_PAGE_IP_ALIGN, equivalent to NET_IP_ALIGN
Date: Tue, 14 May 2013 09:32:18 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7235@saturn3.aculab.com>
In-Reply-To: <1368482311.3305.48.camel@bwh-desktop.uk.solarflarecom.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv2 net 1/2] sfc: Delete EFX_PAGE_IP_ALIGN, equivalent to NET_IP_ALIGN
Thread-Index: Ac5QJQLiCik5nL1SQDaANYIdtgNHqQAV5bvA
References: <1368482311.3305.48.camel@bwh-desktop.uk.solarflarecom.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Ben Hutchings" <bhutchings@solarflare.com>,
        "David Miller" <davem@davemloft.net>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
Cc: <linux-net-drivers@solarflare.com>,
        "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, "netdev" <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4E8XsK6006204

> The two architectures that define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> (powerpc and x86) now both define NET_IP_ALIGN as 0, so there is no
> need for this optimisation any more.

Hmmm.... even on x86 there will be a measurable cost
in misaligned accesses - at least for some workloads.

If the DMA is able to write to a mis-aligned buffer and
still perform aligned burst transfers mid-frame then
4n+2 aligning the rx buffer should be a win even on x86.

Note to hardware engineers: add an option to write two
bytes of junk before the rx data :-)

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
