Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab3BSRtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:49:16 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.90]:30855 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933041Ab3BSRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:49:13 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Topic: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
 Driver
Thread-Index: AQHOC6xQKsSDc1Q1WkuxN29CXfjd55iB8XAA//+EDqA=
Date: Tue, 19 Feb 2013 17:48:39 +0000
Message-ID: <1ca36b5d55c64ac6b8854c4f216ef8e5@DFM-TK5MBX15-06.exchange.corp.microsoft.com>
References: <1360955396-14183-1-git-send-email-haiyangz@microsoft.com>
 <20130219165118.GA17715@aepfle.de>
In-Reply-To: <20130219165118.GA17715@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.17;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51704002)(13464002)(377454001)(24454001)(164054002)(189002)(199002)(56816002)(4396001)(50466001)(31966008)(23676001)(79102001)(16406001)(50986001)(5343655001)(44976002)(74662001)(77982001)(59766001)(51856001)(74502001)(47446002)(56776001)(65816001)(76482001)(47976001)(47736001)(49866001)(876001)(54356001)(54316002)(63696002)(47776003)(33646001)(20776003)(66066001)(80022001)(53806001)(46102001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2SR01MB609;H:hybrid.exchange.microsoft.com;RD:mail1.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0762FFD075
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1JHnGtn031072

> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Tuesday, February 19, 2013 11:51 AM
> To: Haiyang Zhang
> Cc: FlorianSchandinat@gmx.de; linux-fbdev@vger.kernel.org; KY Srinivasan;
> jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH RFC] video: Add Hyper-V Synthetic Video Frame Buffer
> Driver
> 
> On Fri, Feb 15, Haiyang Zhang wrote:
> 
> > @@ -508,6 +544,18 @@ static int __init vesafb_init(void)
> >  	int ret;
> >  	char *option = NULL;
> >
> > +#if IS_ENABLED(CONFIG_HYPERV_FB)
> > +	/*
> > +	 * On Hyper-V both the emulated and synthetic video devices are
> > +	 * available. To avoid conflicts, we disable vesafb for the
> emulated
> > +	 * video if hyperv_fb is configured.
> > +	 */
> > +	if (is_hyperv()) {
> > +		pr_info("Disabled vesafb on Hyper-V.\n");
> > +		return -ENODEV;
> > +	}
> > +#endif
> 
> What is the reason for this hook? Is it not possible to claim the
> display like its appearently done by other drivers (like radeonfb can
> take over display from vesafb)?

The emulated video device is a separate device from the synthetic video.
The synthetic driver can only take control of the synthetic video, but not
the emulated video.

Actually, we already have a similar mechanism in ata/ata_piix.c to disable
emulated IDE drive on Hyper-V, so it won't conflict with the synthetic drive.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
