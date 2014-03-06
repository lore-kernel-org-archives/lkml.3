Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaCFEzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:55:21 -0500
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:36521
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750969AbaCFEzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:55:19 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Alan Stern <stern@rowland.harvard.edu>, Jagdish Gedia <jvgediya@gmail.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: USB remote wakeup through gpio interrupt
Thread-Topic: USB remote wakeup through gpio interrupt
Thread-Index: AQHPOH5yAmOalqDX80aVtzyyTCiHRJrSqH0AgADUoeA=
Date: Thu, 6 Mar 2014 04:54:58 +0000
Message-ID: <975d7885a8b64971923466f9f06a6229@BL2PR03MB226.namprd03.prod.outlook.com>
References: <CAOAoqGuicMKJ8e6kmQ92fL73UpvBzfXx9kafP4tCbUKkiT2=vA@mail.gmail.com>
 <Pine.LNX.4.44L0.1403051101430.1629-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1403051101430.1629-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(51704005)(56816005)(90146001)(33646001)(63696002)(87936001)(47446002)(80022001)(74706001)(79102001)(95666003)(74316001)(15202345003)(2171001)(4396001)(69226001)(77982001)(81542001)(94946001)(51856001)(74876001)(80976001)(81686001)(19580395003)(83322001)(54356001)(92566001)(76482001)(54316002)(19580405001)(81342001)(76786001)(94316002)(76796001)(46102001)(95416001)(76576001)(53806001)(85852003)(83072002)(15975445006)(49866001)(47976001)(47736001)(87266001)(66066001)(74366001)(65816001)(59766001)(2656002)(50986001)(86362001)(93136001)(81816001)(31966008)(85306002)(74502001)(93516002)(77096001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB417;H:BL2PR03MB226.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:BEF7C015.27C61F19.2BE72D4F.CCD4D1B9.2029C;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> > Hi,
> > There is some inconsistency in remote wakeup functionality in my
> > custom board. so I want to wakeup the runtime suspended USB host
> > through interrupt. My USB device is connected to the board through USB
> > interface and some gpios. device will give interrupt on processor gpio
> > when it needs attention of USB host. What should i do so that i can
> > wakeup the usb host when i get interrupt from the device.
> 
> Have your gpio interrupt handler call pm_request_resume() for the host
> controller device.
> 
> However, this may not do what you want.  Since the root hub will remain
> suspended, the host controller will go back to low-power immediately
> after it is resumed.  You really need to resume the USB device itself,
> not the host controller.
> 

I think it is the same we echo on > ../power/control, you may need
to request gpio interrupt at your usb class driver, and call pm_runtime_get()
when the gpio interrupt is coming. After the device finishes using
usb, it can call pm_runtme_put through gpio interrupt.

Peter

> > My idea was to apply power management related hooks from the interrupt
> > handler, but I am not getting the clear idea.
> >
> > My main doubt is,
> > Will this mechanism be efficient as remote wakeup functionality?
> 
> That's a hard question to answer without measurements.  But it shouldn't
> matter, because you probably won't get more than one wakeup per second,
> right?
> 
> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 

