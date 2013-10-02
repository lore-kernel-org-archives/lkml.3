Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3JBSqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:46:23 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:52881
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753935Ab3JBSqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:46:21 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mike Christie <michaelc@cs.wisc.edu>, Jack Wang <xjtuwjp@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: Drivers: scsi: FLUSH timeout
Thread-Topic: Drivers: scsi: FLUSH timeout
Thread-Index: AQHOtkBtWGcmfS/7wkmW+8Ppp9OK8pnPmBJggAU49YCAAAdE0IAAT/uAgABKyICAALYxAIALo8Yg
Date: Wed, 2 Oct 2013 18:29:00 +0000
Message-ID: <ff6a93ed5d234c14874d03415812a3ec@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
	<20130920203222.GA14306@kroah.com>
	<a97d266e2c284d688d2dd7ad43f179b8@SN2PR03MB061.namprd03.prod.outlook.com>
	<524180B7.7090307@gmail.com>
	<3413dbd7fa254fd380a84fe6d9cd87e1@SN2PR03MB061.namprd03.prod.outlook.com>
	<5241C9E7.2000404@cs.wisc.edu>
	<bf168ab724a140f989ab3dfe877b750f@SN2PR03MB061.namprd03.prod.outlook.com>
 <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
In-Reply-To: <CAMuHMdV-BsKc-c1YhzqFrUGJhw+jMZEXXTcT2xyDLnw-JQuVaQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.94]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0987ACA2E2
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(51704005)(24454002)(377454003)(199002)(189002)(65816001)(83072001)(59766001)(80022001)(63696002)(77982001)(81542001)(54316002)(49866001)(81342001)(47976001)(50986001)(47736001)(56776001)(80976001)(33646001)(74316001)(74366001)(83322001)(19580405001)(53806001)(4396001)(19580395003)(79102001)(69226001)(56816003)(77096001)(74502001)(47446002)(76786001)(76796001)(74662001)(31966008)(54356001)(76482001)(74876001)(46102001)(81816001)(51856001)(74706001)(66066001)(81686001)(76576001)(85306001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:131.107.192.94;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r92IkTM6027983



> -----Original Message-----
> From: geert.uytterhoeven@gmail.com [mailto:geert.uytterhoeven@gmail.com]
> On Behalf Of Geert Uytterhoeven
> Sent: Wednesday, September 25, 2013 1:40 AM
> To: KY Srinivasan
> Cc: Mike Christie; Jack Wang; Greg KH; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: Drivers: scsi: FLUSH timeout
> 
> On Tue, Sep 24, 2013 at 11:53 PM, KY Srinivasan <kys@microsoft.com> wrote:
> > I am not sure how that magic number was arrived at (the 60HZ number). We
> want this to be little higher -
> 
> "60 * HZ" means "60 seconds".
> 
> > would there be any issues raising this to say  180 seconds. This is the value we
> currently have for I/O
> > timeout.
> 
> So you want to replace it by "180 * HZ", which is ... another magic number?

Ideally, I want this to be adjustable like the way we can change the I/O timeout.
Since that has been attempted earlier and rejected (not clear what the reasons were),
I was suggesting that we pick a larger number. James, let me know how I should proceed here.

Regards,

K. Y
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
