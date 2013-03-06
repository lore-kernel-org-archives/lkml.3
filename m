Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab3CFJju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:39:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab3CFJjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:39:47 -0500
Date: Wed, 6 Mar 2013 11:38:53 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hu Tao <hutao@cn.fujitsu.com>, Peter Maydell <peter.maydell@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Markus Armbruster <armbru@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        Orit Wasserman <owasserm@redhat.com>, kvm list <kvm@vger.kernel.org>,
        Juan Quintela <quintela@redhat.com>, Alexander Graf <agraf@suse.de>,
        Andrew Jones <drjones@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kevin Wolf <kwolf@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 0/8] pv event interface between host and guest
Message-ID: <20130306093852.GK11223@redhat.com>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <20130303091738.GB23616@redhat.com>
 <513471F1.5020702@redhat.com>
 <20130306085628.GB4719@localhost.localdomain>
 <51370753.90806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51370753.90806@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 10:07:31AM +0100, Paolo Bonzini wrote:
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
> Later we can change this to use fw-cfg.
> 
I thought we agreed to do it from the start :)

--
			Gleb.
