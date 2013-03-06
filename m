Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3CFJ2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:28:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41215 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756552Ab3CFJ2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:28:49 -0500
X-IronPort-AV: E=Sophos;i="4.84,794,1355068800"; 
   d="scan'208";a="6823573"
Subject: Re: [Qemu-devel] [PATCH v13 0/8] pv event interface between host
 and guest
From: li guang <lig.fnst@cn.fujitsu.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hu Tao <hutao@cn.fujitsu.com>, Kevin Wolf <kwolf@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Andrew Jones <drjones@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm list <kvm@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Juan Quintela <quintela@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Markus Armbruster <armbru@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, Blue Swirl <blauwirbel@gmail.com>,
        Orit Wasserman <owasserm@redhat.com>, Alexander Graf <agraf@suse.de>,
        Sasha Levin <levinsasha928@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <51370753.90806@redhat.com>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
	 <20130303091738.GB23616@redhat.com> <513471F1.5020702@redhat.com>
	 <20130306085628.GB4719@localhost.localdomain>  <51370753.90806@redhat.com>
Date: Wed, 06 Mar 2013 17:28:08 +0800
Message-ID: <1362562088.21129.40.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 17:27:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 17:27:44,
	Serialize complete at 2013/03/06 17:27:44
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-03-06三的 10:07 +0100，Paolo Bonzini写道：
> Il 06/03/2013 09:56, Hu Tao ha scritto:
> >> > 
> >> > Something like this should work (in SeaBIOS's src/acpi-dsdt-isa.dsl):
> >> > 
> >> >     Device(PEVT) {
> >> >         Name(_HID, EisaId("QEMU0001"))
> >> >         OperationRegion(PEOR, SystemIO, 0x505, 0x01)
> >> >         Field(PEOR, ByteAcc, NoLock, Preserve) {
> >> >             PEPT,   8,
> >> >         }
> >> > 
> >> >         Method(_STA, 0, NotSerialized) {
> >> >             Store(PEPT, Local0)
> >> >             If (LEqual(Local0, Zero)) {
> >> >                 Return (0x00)
> >> >             } Else {
> >> >                 Return (0x0F)
> >> >             }
> >> >         }
> > IIUC, here _STA reads from ioport 0x505, if the result is 0, then the
> > device is not present. Otherwise, the device is present. But as Gleb
> > said, ''the data you read from unassigned port is not guarantied to be
> > zero, it may depend on QEMU version''. What should I do to tell if the
> > device is present or not correctly?
> 
> The firmware is tied to the QEMU version, so you can rely on unassigned
> ports returning zero.
> 

but what if we happen to transfer data end by 0x0,
here, will this device(QEMU0001) disappear?
(by this asl code snippet, I think it will)
so, if we transfer data(not 0x0) device appear,
then, it will disappear(if come across 0x0),
can this happen?
or should we use another status io port e.g.
0x506 to handle this condition?

> Later we can change this to use fw-cfg.
> 
> Paolo
> 
> 


