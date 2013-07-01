Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3GAOgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:36:42 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:35066
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745Ab3GAOgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:36:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI9371I936eI542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>, Timur Tabi <timur@tabi.org>
Subject: RE: [PATCH 3/3 v18] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Topic: [PATCH 3/3 v18] iommu/fsl: Freescale PAMU driver and iommu
 implementation.
Thread-Index: AQHOdkTGrSQ0ACTD1kSgCKgCe/0gIplP4+oAgAAARqA=
Date: Mon, 1 Jul 2013 14:36:35 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D0A34A7F5@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1372673475-20929-1-git-send-email-Varun.Sethi@freescale.com>
 <1372689326.30572.788.camel@ul30vt.home>
In-Reply-To: <1372689326.30572.788.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.172]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r61Eap5A000952

Thanks Alex.

> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Monday, July 01, 2013 8:05 PM
> To: Sethi Varun-B16395
> Cc: joro@8bytes.org; iommu@lists.linux-foundation.org; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> benh@kernel.crashing.org; galak@kernel.crashing.org; Yoder Stuart-B08248;
> Wood Scott-B07421; Timur Tabi
> Subject: Re: [PATCH 3/3 v18] iommu/fsl: Freescale PAMU driver and iommu
> implementation.
> 
> On Mon, 2013-07-01 at 15:41 +0530, Varun Sethi wrote:
> > Following is a brief description of the PAMU hardware:
> > PAMU determines what action to take and whether to authorize the
> > action on the basis of the memory address, a Logical IO Device Number
> > (LIODN), and PAACT table (logically) indexed by LIODN and address.
> > Hardware devices which need to access memory must provide an LIODN in
> addition to the memory address.
> >
> > Peripheral Access Authorization and Control Tables (PAACTs) are the
> > primary data structures used by PAMU. A PAACT is a table of peripheral
> > access authorization and control entries (PAACE).Each PAACE defines
> > the range of I/O bus address space that is accessible by the LIOD and
> > the associated access capabilities.
> >
> > There are two types of PAACTs: primary PAACT (PPAACT) and secondary
> > PAACT (SPAACT).A given physical I/O device may be able to act as one
> > or more independent logical I/O devices (LIODs). Each such logical I/O
> > device is assigned an identifier called logical I/O device number
> > (LIODN). A LIODN is allocated a contiguous portion of the I/O bus
> > address space called the DSA window for performing DSA operations. The
> > DSA window may optionally be divided into multiple sub-windows, each
> > of which may be used to map to a region in system storage space. The
> > first sub-window is referred to as the primary sub-window and the
> remaining are called secondary sub-windows.
> >
> > This patch provides the PAMU driver (fsl_pamu.c) and the corresponding
> > IOMMU API implementation (fsl_pamu_domain.c). The PAMU hardware driver
> > (fsl_pamu.c) has been derived from the work done by Ashish Kalra and
> Timur Tabi.
> >
> > Signed-off-by: Timur Tabi <timur@tabi.org>
> > Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
> > ---
> 
> For iommu group support
> 
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
