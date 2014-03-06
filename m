Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaCFJeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:34:46 -0500
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:3538
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750885AbaCFJem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:34:42 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Jagdish Gedia <jvgediya@gmail.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: USB remote wakeup through gpio interrupt
Thread-Topic: USB remote wakeup through gpio interrupt
Thread-Index: AQHPOH5yAmOalqDX80aVtzyyTCiHRJrSqH0AgADUoeCAABOzAIAAAH/wgAA5NICAAAF4AIAAAP8g
Date: Thu, 6 Mar 2014 09:34:40 +0000
Message-ID: <f48282eff10c475d82034576c081614d@BL2PR03MB226.namprd03.prod.outlook.com>
References: <CAOAoqGuicMKJ8e6kmQ92fL73UpvBzfXx9kafP4tCbUKkiT2=vA@mail.gmail.com>
	<Pine.LNX.4.44L0.1403051101430.1629-100000@iolanthe.rowland.org>
	<975d7885a8b64971923466f9f06a6229@BL2PR03MB226.namprd03.prod.outlook.com>
	<CAOAoqGvzxsnpopgi4-DtfUp-zXbq6iV0J_y18Q0NgZ1AGzSu2Q@mail.gmail.com>
	<3a0fb59a555b40aca5610ef00626fdba@BL2PR03MB226.namprd03.prod.outlook.com>
	<CAOAoqGu4exeZP2wgEWpRyD7+4RVRbB=vOe4Hc+rK3CVVigCWvg@mail.gmail.com>
 <CAOAoqGtiNe9QE+Bu3inva51qp1STKNOsEDG9b6Q7JBh7atQQrA@mail.gmail.com>
In-Reply-To: <CAOAoqGtiNe9QE+Bu3inva51qp1STKNOsEDG9b6Q7JBh7atQQrA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(24454002)(51704005)(164054003)(199002)(377454003)(81686001)(81816001)(79102001)(74316001)(76576001)(66066001)(59766001)(95666003)(77982001)(81542001)(80022001)(97336001)(65816001)(77096001)(76786001)(80976001)(74706001)(74366001)(19580395003)(33646001)(19580405001)(83322001)(63696002)(76796001)(81342001)(69226001)(4396001)(53806001)(86362001)(93516002)(47976001)(47446002)(85852003)(90146001)(76482001)(74662001)(51856001)(93136001)(83072002)(87266001)(2656002)(97186001)(46102001)(74502001)(92566001)(50986001)(54316002)(56776001)(49866001)(74876001)(56816005)(87936001)(94946001)(85306002)(31966008)(1411001)(95416001)(47736001)(94316002)(54356001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB419;H:BL2PR03MB226.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:AC1770EC.2E714509.B375B96E.87D9DD43.201EB;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
> 
> Hi Peter,
> 
> My usb device is not capable of giving interrupt when it finishes using
> usb. So i dont have any idea where can i call pm_runtime_put for my usb
> device?
> 
> the other thing is that, earlier you have told, waking up usb device
> through interrupt is same as writing "on" to ../power/control , but i
> think writing "on" to ../power/control will disable the autosuspend for
> usb device in future, but i want autosuspend to be enabled for my usb
> device always. Will using pm_runtime_get and pm_runtime_put cause the
> disable of autosuspend for usb device?
> 

It is not related to autosuspend. Make sure you use above two APIs in pair.
Of cos, writing "on" to "../power/control" will disable autosuspend.

Peter

> 
> Thanks,
> Jagdish Gediya
> 
> On Thu, Mar 6, 2014 at 2:53 PM, Jagdish Gedia <jvgediya@gmail.com> wrote:
> > Hi Alan,
> >
> > As you have told, i have executed pm_request_resume() function from my
> > interrupt handler, and it is waking up my USB device. I have
> > implemented all this functionality in class driver(cdc-acm.c).
> > but what is happening is after 2-3 times, ausosuspend is getting
> > disable for my device. I want autosuspend to be enabled for usb device
> > forever. Do pm_request_resume function causes this behavior?
> >
> >
> >
> > Thanks,
> > Jagdish Gediya
> 

