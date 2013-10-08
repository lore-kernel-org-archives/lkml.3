Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3JHOsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 10:48:35 -0400
Received: from [207.46.163.241] ([207.46.163.241]:16026 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754787Ab3JHOsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 10:48:33 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "open list:Hyper-V CORE AND..." <devel@linuxdriverproject.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] hyperv-fb: add pci stub
Thread-Topic: [PATCH 1/2] hyperv-fb: add pci stub
Thread-Index: AQHOv2bVQASfGfm0ykyTRCW4KfZb6JnheAxggAdcMICAAK2d4IABA6IAgABjotA=
Date: Tue, 8 Oct 2013 14:48:19 +0000
Message-ID: <869742b7d84a4ee5a1f8733c2058baff@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
	 <465ef0cb45e04bcc94c4788c0d930c4d@SN2PR03MB061.namprd03.prod.outlook.com>
	 <1381128633.13574.3.camel@nilsson.home.kraxel.org>
	 <f5746838b7654aac98a5753d669196b4@SN2PR03MB061.namprd03.prod.outlook.com>
 <1381221672.5823.30.camel@nilsson.home.kraxel.org>
In-Reply-To: <1381221672.5823.30.camel@nilsson.home.kraxel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [174.61.203.63]
x-forefront-prvs: 0993689CD1
x-forefront-antispam-report: SFV:NSPM;SFS:(377424004)(24454002)(377454003)(199002)(189002)(13464003)(52604005)(51704005)(77096001)(74662001)(31966008)(81686001)(76576001)(76786001)(69226001)(76796001)(74502001)(47446002)(54356001)(76482001)(51856001)(46102001)(81816001)(74706001)(74876001)(66066001)(83322001)(81542001)(33646001)(63696002)(83072001)(80022001)(65816001)(59766001)(54316002)(79102001)(53806001)(19580395003)(74316001)(74366001)(77982001)(19580405001)(56816003)(56776001)(4396001)(49866001)(47736001)(85306002)(80976001)(47976001)(81342001)(50986001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:174.61.203.63;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: DuplicateDomain-a84fc36a-4ed7-4e57-ab1c-3e967bcbad48.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r98EmcX4004751



> -----Original Message-----
> From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> Sent: Tuesday, October 08, 2013 1:41 AM
> To: KY Srinivasan
> Cc: Haiyang Zhang; Jean-Christophe Plagniol-Villard; Tomi Valkeinen; open
> list:Hyper-V CORE AND...; open list:FRAMEBUFFER LAYER; open list
> Subject: Re: [PATCH 1/2] hyperv-fb: add pci stub
> 
> On Mo, 2013-10-07 at 17:12 +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Gerd Hoffmann [mailto:kraxel@redhat.com]
> > > Sent: Sunday, October 06, 2013 11:51 PM
> > > To: KY Srinivasan
> > > Cc: Haiyang Zhang; Jean-Christophe Plagniol-Villard; Tomi Valkeinen; open
> > > list:Hyper-V CORE AND...; open list:FRAMEBUFFER LAYER; open list
> > > Subject: Re: [PATCH 1/2] hyperv-fb: add pci stub
> > >
> > > On Mi, 2013-10-02 at 14:29 +0000, KY Srinivasan wrote:
> > > >
> > > > > This patch adds a pci stub driver to hyper-fb.  The hyperv framebuffer
> > > > > driver will bind to the pci device then, so linux kernel and userspace
> > > > > know there is a proper kernel driver for the device active.  lspci shows
> > > > > this for example:
> > >
> > > > Gerd,
> > > >
> > > > Thanks for doing this. This certainly will address some of the issues that are
> > > reported. I do have a question though - how would this work if we don't have
> PCI
> > > bus in the guest.
> > >
> > > The hyperv framebuffer driver wouldn't work in the first place then as
> > > it looks up the framebuffer address in pci config space (see hvfb_getmem
> > > function).
> >
> > We are going to fix this as we move this code to run on our UEFI firmware.
> 
> Hmm, windows server 2012 seems to have no option to enable uefi.  So I
> guess this is still in development?  How this is going to look like?

This feature is there in WS2012 R2
> 
> Probably you are going for pure uefi firmware, without csm, to be able
> to leave all the legacy bios stuff behind in uefi mode.  Therefore no
> vesa bios support.  efi drivers for vmbus network/storage/display/input
> in the firmware.  No legacy ide/vga pci devices.  Correct?
> 
Something on these lines.

> The linux kernel will come up with efifb then, switching over to
> hyperv-fb once the driver is loaded.  The hyperv-fb pci stub driver will
> not bind to the hyperv vga pci device if it isn't present in the guest.
> hyperv-fb will load just fine nevertheless (once hvfb_getmem is fixed to
> not depend on the pci device config space).  The pci stub added by the
> patch and the vmbus driver in hyperv-fb are completely independent.

Ok; thanks.

K. Y
 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
