Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3JYJMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:12:12 -0400
Received: from mx0.aculab.com ([213.249.233.131]:43545 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751586Ab3JYJML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:12:11 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*() family helpers
Date: Fri, 25 Oct 2013 10:10:02 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B73B0@saturn3.aculab.com>
In-Reply-To: <5269D5D1.60103@start.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*() family helpers
Thread-Index: Ac7RKNtOk6v5A3pDTFiVQ12x1oawfgAOCgjg
References: <cover.1382103786.git.agordeev@redhat.com> <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com> <20131024105158.GB13159@mtj.dyndns.org> <AE90C24D6B3A694183C094C60CF0A2F6026B73AA@saturn3.aculab.com> <20131024114133.GA26610@dhcp-26-207.brq.redhat.com> <5269D5D1.60103@start.ca>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Mark Lord" <kernel@start.ca>, "Alexander Gordeev" <agordeev@redhat.com>
Cc: "Tejun Heo" <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "Michael Ellerman" <michael@ellerman.id.au>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Ben Hutchings" <bhutchings@solarflare.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-pci@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9P9CFMV023704

> > pcim_enable_msix_min_max(struct pci_dev *dev, struct msix_entry *entries,
> > 			 unsigned int minvec, unsigned int maxvec);
> 
> The hardware I have in mind here works only for powers of two.
> Eg. 16, 8, 4, 2, or 1 MSI-X vector.  Not the odd values in between.
> 
> But it appears I can still just use a loop for that case,
> calling the new function above instead of the old functions.

You'd either have to loop with min and max the same (starting at 16),
or do a single call with min=1 and max=16 and the release the
unwanted ones.

The latter might be preferred because it might stop an annoying
trace about the system not having enough MSI interrupts.

What this doesn't resolve is a driver requesting a lot of interrupts
early on and leaving none for later drivers.

Really the system needs to allocate the minimum number to all
drivers before giving out any extra ones - I've NFI how this
would be arranged!

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
