Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762884Ab3IDQmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:42:13 -0400
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:39441 "EHLO
	rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935245Ab3IDQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:42:11 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2013 12:42:11 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AisFAExgJ1KtJXHB/2dsb2JhbABagwc1UYMovhcXgRAWdIIkAQEBAwEBAiAEDRohCgUHBAIBCA4DBAEBAQICBh0DAgICJgkBFAEICAIEAQcGBQgVBIdbBgyoLpFFgSmOBhYbBwaCYzSBAAOVLIN4kDeBY4E9gio
X-IronPort-AV: E=Sophos;i="4.89,1022,1367971200"; 
   d="scan'208";a="255525478"
From: "Christian Benvenuti (benve)" <benve@cisco.com>
To: Ben Hutchings <bhutchings@solarflare.com>,
        Govindarajulu Varadarajan <govindarajulu90@gmail.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sujith Sankar (ssujith)" <ssujith@cisco.com>,
        "Nishank Trivedi (nistrive)" <nistrive@cisco.com>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>
Subject: RE: [PATCH net-next 4/5] driver/net: enic: Exposing symbols for
 Cisco's low latency driver
Thread-Topic: [PATCH net-next 4/5] driver/net: enic: Exposing symbols for
 Cisco's low latency driver
Thread-Index: AQHOqTJYJzcQYUgetk+ym8l5YWToFJm1/k4A///G/BA=
Date: Wed, 4 Sep 2013 16:32:32 +0000
Message-ID: <6CE81A2095B0024BBC77007BD04E5538163B23CE@xmb-aln-x02.cisco.com>
References: <1378273638-7780-1-git-send-email-govindarajulu90@gmail.com>
	 <1378273638-7780-5-git-send-email-govindarajulu90@gmail.com>
 <1378306376.3133.7.camel@bwh-desktop.uk.level5networks.com>
In-Reply-To: <1378306376.3133.7.camel@bwh-desktop.uk.level5networks.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.87.117]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r84GgJTU024289

Hi Ben,

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of Ben Hutchings
> Sent: Wednesday, September 04, 2013 7:53 AM
> To: Govindarajulu Varadarajan
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Christian Benvenuti (benve); Sujith Sankar
> (ssujith); Nishank Trivedi (nistrive); Upinder Malhi (umalhi)
> Subject: Re: [PATCH net-next 4/5] driver/net: enic: Exposing symbols for
> Cisco's low latency driver
> 
> On Wed, 2013-09-04 at 11:17 +0530, Govindarajulu Varadarajan wrote:
> > This patch exposes symbols for usnic low latency driver that can be
> > used to register and unregister vNics as well to traverse the resources on
> vNics.
> >
> > Signed-off-by: Upinder Malhi <umalhi@cisco.com>
> > Signed-off-by: Nishank Trivedi <nistrive@cisco.com>
> > Signed-off-by: Christian Benvenuti <benve@cisco.com>
> 
> Will usnic, or any other user of these symbols, be submitted for inclusion in-
> tree as well?  It is generally expected that exported functions do have an in-
> tree user.

The usnic driver has been posted yesterday on the rdma list.
(http://www.spinics.net/lists/linux-rdma/msg16999.html)

/Chris

> Also, header files under drivers/ generally won't be included in distribution
> -devel packages, so to support an out-of-tree module the function
> prototypes would need to be included in a header under include/ (or else
> you have to repeat them and hope the types never change).
> 
> Ben.
> 
> > ---
> >  drivers/net/ethernet/cisco/enic/vnic_dev.c | 10 ++++++++++
> > drivers/net/ethernet/cisco/enic/vnic_dev.h |  1 +
> >  2 files changed, 11 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/cisco/enic/vnic_dev.c
> > b/drivers/net/ethernet/cisco/enic/vnic_dev.c
> > index 97455c5..69dd925 100644
> > --- a/drivers/net/ethernet/cisco/enic/vnic_dev.c
> > +++ b/drivers/net/ethernet/cisco/enic/vnic_dev.c
> > @@ -175,6 +175,7 @@ unsigned int vnic_dev_get_res_count(struct
> > vnic_dev *vdev,  {
> >  	return vdev->res[type].count;
> >  }
> > +EXPORT_SYMBOL(vnic_dev_get_res_count);
> >
> >  void __iomem *vnic_dev_get_res(struct vnic_dev *vdev, enum
> vnic_res_type type,
> >  	unsigned int index)
> > @@ -193,6 +194,7 @@ void __iomem *vnic_dev_get_res(struct vnic_dev
> *vdev, enum vnic_res_type type,
> >  		return (char __iomem *)vdev->res[type].vaddr;
> >  	}
> >  }
> > +EXPORT_SYMBOL(vnic_dev_get_res);
> >
> >  static unsigned int vnic_dev_desc_ring_size(struct vnic_dev_ring *ring,
> >  	unsigned int desc_count, unsigned int desc_size) @@ -942,6 +944,7
> @@
> > void vnic_dev_unregister(struct vnic_dev *vdev)
> >  		kfree(vdev);
> >  	}
> >  }
> > +EXPORT_SYMBOL(vnic_dev_unregister);
> >
> >  struct vnic_dev *vnic_dev_register(struct vnic_dev *vdev,
> >  	void *priv, struct pci_dev *pdev, struct vnic_dev_bar *bar, @@
> > -969,6 +972,13 @@ err_out:
> >  	vnic_dev_unregister(vdev);
> >  	return NULL;
> >  }
> > +EXPORT_SYMBOL(vnic_dev_register);
> > +
> > +struct pci_dev *vnic_dev_get_pdev(struct vnic_dev *vdev) {
> > +	return vdev->pdev;
> > +}
> > +EXPORT_SYMBOL(vnic_dev_get_pdev);
> >
> >  int vnic_dev_init_prov2(struct vnic_dev *vdev, u8 *buf, u32 len)  {
> > diff --git a/drivers/net/ethernet/cisco/enic/vnic_dev.h
> > b/drivers/net/ethernet/cisco/enic/vnic_dev.h
> > index f3d9b79..e670029 100644
> > --- a/drivers/net/ethernet/cisco/enic/vnic_dev.h
> > +++ b/drivers/net/ethernet/cisco/enic/vnic_dev.h
> > @@ -127,6 +127,7 @@ int vnic_dev_set_ig_vlan_rewrite_mode(struct
> > vnic_dev *vdev,  struct vnic_dev *vnic_dev_register(struct vnic_dev *vdev,
> >  	void *priv, struct pci_dev *pdev, struct vnic_dev_bar *bar,
> >  	unsigned int num_bars);
> > +struct pci_dev *vnic_dev_get_pdev(struct vnic_dev *vdev);
> >  int vnic_dev_init_prov2(struct vnic_dev *vdev, u8 *buf, u32 len);
> > int vnic_dev_enable2(struct vnic_dev *vdev, int active);  int
> > vnic_dev_enable2_done(struct vnic_dev *vdev, int *status);
> 
> --
> Ben Hutchings, Staff Engineer, Solarflare Not speaking for my employer;
> that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
