Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaCFGH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:07:58 -0500
Received: from [207.46.163.143] ([207.46.163.143]:19886 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751981AbaCFGH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:07:56 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Jagdish Gedia <jvgediya@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: USB remote wakeup through gpio interrupt
Thread-Topic: USB remote wakeup through gpio interrupt
Thread-Index: AQHPOH5yAmOalqDX80aVtzyyTCiHRJrSqH0AgADUoeCAABOzAIAAAH/w
Date: Thu, 6 Mar 2014 06:05:13 +0000
Message-ID: <3a0fb59a555b40aca5610ef00626fdba@BL2PR03MB226.namprd03.prod.outlook.com>
References: <CAOAoqGuicMKJ8e6kmQ92fL73UpvBzfXx9kafP4tCbUKkiT2=vA@mail.gmail.com>
	<Pine.LNX.4.44L0.1403051101430.1629-100000@iolanthe.rowland.org>
	<975d7885a8b64971923466f9f06a6229@BL2PR03MB226.namprd03.prod.outlook.com>
 <CAOAoqGvzxsnpopgi4-DtfUp-zXbq6iV0J_y18Q0NgZ1AGzSu2Q@mail.gmail.com>
In-Reply-To: <CAOAoqGvzxsnpopgi4-DtfUp-zXbq6iV0J_y18Q0NgZ1AGzSu2Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(51704005)(199002)(81686001)(81816001)(79102001)(74316001)(76576001)(59766001)(95666003)(66066001)(77982001)(81542001)(80022001)(65816001)(77096001)(76786001)(80976001)(74366001)(74706001)(63696002)(33646001)(76796001)(83322001)(81342001)(69226001)(4396001)(53806001)(86362001)(93516002)(47976001)(47446002)(90146001)(85852003)(76482001)(74502001)(93136001)(50986001)(51856001)(83072002)(87266001)(2656002)(46102001)(92566001)(54316002)(49866001)(74876001)(56816005)(87936001)(94946001)(85306002)(31966008)(1411001)(95416001)(47736001)(94316002)(54356001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB419;H:BL2PR03MB226.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:F237F3AC.53B01B29.4BEC617C.D4CA8AE0.20185;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
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
> Thanks for your reply.
> 
> I can use pm_runtime_get in interrupt handler, but i am not getting your
> idea of using pm_runtime_put in interrupt handler?
> 

After your device finishes using usb, it may need to toggle gpio to trigger
interrupt, and you can suspend usb at this interrupt handler using pm_runtime_put.

> My device is usb telephony modem, which will give interrupt through gpio
> when call comes. so at that time i want to wakeup the usb functionality
> as remote wakeup is not working properly.
> 
> will pm_runtime_put suspend the device immidiately or it will not suspend
> the device till it is in use?
> 

It should suspend device immediately if you have not set any timeout value
for runtime. You call pm_runtime_put, it means you want to stop using device,
the host will stop sending SOF after it finishes suspending bus routine.

Peter
 

