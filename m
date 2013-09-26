Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3IZDxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:53:25 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:14908
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477Ab3IZDxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:53:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zz98dI9371I936eI542I1432Id725ozz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Bhushan Bharat-R65777 <R65777@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "joro@8bytes.org" <joro@8bytes.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [PATCH 5/7] iommu: supress loff_t compilation error on powerpc
Thread-Topic: [PATCH 5/7] iommu: supress loff_t compilation error on powerpc
Thread-Index: AQHOtQsTkIrILle2u0SQwk+H1qQDHJnWscqAgAC7gTA=
Date: Thu, 26 Sep 2013 03:53:12 +0000
Message-ID: <6A3DF150A5B70D4F9B66A25E3F7C888D07183CA4@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-6-git-send-email-Bharat.Bhushan@freescale.com>
 <1380127227.3030.316.camel@ul30vt.home>
In-Reply-To: <1380127227.3030.316.camel@ul30vt.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.2]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8Q3rVTR011511



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Wednesday, September 25, 2013 10:10 PM
> To: Bhushan Bharat-R65777
> Cc: joro@8bytes.org; benh@kernel.crashing.org; galak@kernel.crashing.org; linux-
> kernel@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> pci@vger.kernel.org; agraf@suse.de; Wood Scott-B07421; iommu@lists.linux-
> foundation.org; Bhushan Bharat-R65777
> Subject: Re: [PATCH 5/7] iommu: supress loff_t compilation error on powerpc
> 
> On Thu, 2013-09-19 at 12:59 +0530, Bharat Bhushan wrote:
> > Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_rdwr.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
> > b/drivers/vfio/pci/vfio_pci_rdwr.c
> > index 210db24..8a8156a 100644
> > --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> > +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> > @@ -181,7 +181,8 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char
> __user *buf,
> >  			       size_t count, loff_t *ppos, bool iswrite)  {
> >  	int ret;
> > -	loff_t off, pos = *ppos & VFIO_PCI_OFFSET_MASK;
> > +	loff_t off;
> > +	u64 pos = (u64 )(*ppos & VFIO_PCI_OFFSET_MASK);
> >  	void __iomem *iomem = NULL;
> >  	unsigned int rsrc;
> >  	bool is_ioport;
> 
> What's the compile error that this fixes?

I was getting below error; and after some googling I came to know that this is how it is fixed by other guys.

/home/r65777/linux-vfio/drivers/vfio/pci/vfio_pci_rdwr.c:193: undefined reference to `__cmpdi2'
/home/r65777/linux-vfio/drivers/vfio/pci/vfio_pci_rdwr.c:193: undefined reference to `__cmpdi2'

Thanks
-Bharat
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
