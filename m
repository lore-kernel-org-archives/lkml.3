Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331Ab3HIO4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:56:18 -0400
Received: from mx2.parallels.com ([199.115.105.18]:48269 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883Ab3HIO4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:56:16 -0400
From: James Bottomley <jbottomley@parallels.com>
To: =?utf-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S.Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: DMA masks
Thread-Topic: DMA masks
Thread-Index: AQHOlOEwT7cC2v0Ickivfe8BTFEyZJmNbMSA
Date: Fri, 9 Aug 2013 14:56:14 +0000
Message-ID: <1376060173.2087.4.camel@dabdike.int.hansenpartnership.com>
References: <m3fvujgrcr.fsf@t19.piap.pl>
In-Reply-To: <m3fvujgrcr.fsf@t19.piap.pl>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.17.213.192]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B86D67E7DEA0CD4CB1FAC9516FD13E3E@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r79EuNcu010597

On Fri, 2013-08-09 at 11:12 +0200, Krzysztof HaÅ‚asa wrote:
> Hi,
> 
> I'm trying to understand why the struct device contains a pointer to
> dma_mask and not the actual dma_mask:

It's an anachronism.  The original reason was when this was introduced,
struct pci_device was the only device that actually had one.  On PA-RISC
we needed to walk the device tree by generic device and set the DMA mask
on generic devices, which meant we either had to special case the PCI
device, rearchitect the whole of the PCI device mask setting to use the
generic device, or cheat and make the generic device dma mask a pointer
to the PCI one.  I took the latter option because it's simpler.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
