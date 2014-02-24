Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaBXWHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:07:09 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.25]:3423 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010AbaBXWHD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:07:03 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Gerd Hoffmann <kraxel@redhat.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        KY Srinivasan <kys@microsoft.com>,
        "Abhishek Gupta (LIS)" <abgupta@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: RE: [PATCH v3 4/4] hyperv-fb: kick off efifb early
Thread-Topic: [PATCH v3 4/4] hyperv-fb: kick off efifb early
Thread-Index: AQHPMWLdNQjp+wQ520eGPYGYJR/DV5rE9mTw
Date: Mon, 24 Feb 2014 22:06:36 +0000
Message-ID: <771a0b10157b48bab970b5360ec54956@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
References: <1393247831-5271-1-git-send-email-kraxel@redhat.com>
 <1393247831-5271-5-git-send-email-kraxel@redhat.com>
In-Reply-To: <1393247831-5271-5-git-send-email-kraxel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(51704005)(13464003)(164054003)(189002)(199002)(377454003)(95666003)(81542001)(81342001)(93136001)(85852003)(83072002)(46102001)(49866001)(92566001)(33646001)(51856001)(90146001)(54316002)(77982001)(59766001)(2656002)(74706001)(87266001)(56816005)(81816001)(87936001)(56776001)(46406003)(76796001)(76786001)(86612001)(95416001)(94946001)(74366001)(23726002)(50986001)(74876001)(31966008)(94316002)(76482001)(50466002)(65816001)(66066001)(47736001)(93516002)(69226001)(85306002)(80022001)(81686001)(47976001)(54356001)(53806001)(6806004)(74502001)(44976005)(47446002)(83322001)(19580405001)(19580395003)(84676001)(79102001)(20776003)(80976001)(47776003)(4396001)(63696002)(74662001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB591;H:hybrid.exchange.microsoft.com;FPR:34EE6D0E.2BD1548A.E3EFDB42.B0E6AA11.20283;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0132C558ED
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> Sent: Monday, February 24, 2014 8:17 AM
> To: linux-fbdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; KY Srinivasan;
> Abhishek Gupta (LIS); Haiyang Zhang; jasowang@redhat.com;
> tomi.valkeinen@ti.com; devel@linuxdriverproject.org; Gerd Hoffmann; Jean-
> Christophe Plagniol-Villard
> Subject: [PATCH v3 4/4] hyperv-fb: kick off efifb early
> 
> Remove firmware framebuffer before initializing hyperv-fb.  Needed
> on gen2 virtual machines.   Letting register_framebuffer handle the
> switchover results in efifb still being active while hyperv graphics are
> initialized, which in turn can make the linux kernel hang.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  drivers/video/hyperv_fb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c index
> 135d8cd..a570836 100644
> --- a/drivers/video/hyperv_fb.c
> +++ b/drivers/video/hyperv_fb.c
> @@ -683,6 +683,7 @@ static int hvfb_getmem(struct fb_info *info)
>  		info->apertures->ranges[0].base = pci_resource_start(pdev, 0);
>  		info->apertures->ranges[0].size = pci_resource_len(pdev, 0);
>  	}
> +	remove_conflicting_framebuffers(info->apertures, "hyperv-fb", false);

Please use KBUILD_MODNAME, so that the naming is consistent.

Thanks,
- Haiyang

> 
>  	info->fix.smem_start = par->mem.start;
>  	info->fix.smem_len = screen_fb_size;
> --
> 1.8.3.1

