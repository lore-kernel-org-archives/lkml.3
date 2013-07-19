Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965774Ab3GSKkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:40:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16615 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934447Ab3GSKku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:40:50 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-58-51e917b062c4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Re: libata / IDE cs5536: 80c cable detect issue (and worse?)
Date: Fri, 19 Jul 2013 12:40:38 +0200
Message-id: <21479812.cJNm40xAqz@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <20130718182541.GA30707@rhlx01.hs-esslingen.de>
References: <20130718181355.GA31889@rhlx01.hs-esslingen.de>
 <20130718182541.GA30707@rhlx01.hs-esslingen.de>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd0N4i8DDdb0qVhc/veGxeL7lutM
	FpP23GSyOLbjEZPF5V1z2CyWH//H5MDmsXPWXXaPJTfVPD4+vcXi8XmTXABLFJdNSmpOZllq
	kb5dAlfGlJX/WArmcVY8m9nD3sC4n72LkZNDQsBEYurhRmYIW0ziwr31bF2MXBxCAtMZJXqe
	3mCBcFqYJE4t3gFWxSZgJTGxfRUjiC0ioCDxr2snK0gRs8BVRonOG1vYQBLCAp4S3dvegzWw
	CKhKzF5+FczmFdCS6G46xQJiiwq4Spxb9APM5hSwkWh/cw2sRkggV+LezeOsEPWCEj8m3wOr
	YRaQl9i3fyorhK0lsX7ncaYJjAKzkJTNQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6
	yfm5mxjBIf1MagfjygaLQ4wCHIxKPLwPvjwPFGJNLCuuzD3EKMHBrCTC+yv5RaAQb0piZVVq
	UX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxmOT/CrYmj8wMt1mXMt0
	SNQ9S27ljVcpv042WetNbspdw/PZ5uOUzom+zFdr5VMV20sv3NWS+bhlScdXlR/dTjYnk/5O
	Z1tgn/L0ruHLS6+7Tus7uh+3/eXz7/jmxRGPmuRCYyff5vuj3X4gQjakr6jsutK6q8LSLQvV
	V3UJpEboHNYLXCUtp8RSnJFoqMVcVJwIAEagbxplAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, July 18, 2013 08:25:41 PM Andreas Mohr wrote:
> Hi,
> 
> forgot to mention that I had already added a libata.force=40c boot
> after my 80c config issue discovery
> which did successfully cause the "limiting to UDMA/33 due to 40c foo" dmesg
> yet where there's now initial but strong confirmation via reports
> that the resulting UDMA/33 limit did NOT manage to fix corruption issues,
> thus it's more strongly likely that the "bound to ill-suited pata_amd driver"
> (due to incorrectly configuring speeds, or due to not configuring speeds
> at all due to possibly BIOS not providing emulation of PCI register accesses
> to Geode bus, which would be properly supported by pata_cs5536 OTOH)
> thing is the actual reason and might fix it (fingers crossed).

UDMA/66 (and higher) requires 80-wire cable to work (if the vendor states
that UDMA/66 is supported then UDMA/100 should also work on CS5536). UDMA/33
should work just fine with 40-wire cable. Therefore this indeed sounds more
like wrong driver being selected issue than a cable problem.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

