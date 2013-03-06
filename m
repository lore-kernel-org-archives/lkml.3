Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab3CFJHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:07:44 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64870 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3CFJHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:07:38 -0500
Message-ID: <51370753.90806@redhat.com>
Date: Wed, 06 Mar 2013 10:07:31 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Hu Tao <hutao@cn.fujitsu.com>
CC: Peter Maydell <peter.maydell@linaro.org>, Gleb Natapov <gleb@redhat.com>,
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
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <20130303091738.GB23616@redhat.com> <513471F1.5020702@redhat.com> <20130306085628.GB4719@localhost.localdomain>
In-Reply-To: <20130306085628.GB4719@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/03/2013 09:56, Hu Tao ha scritto:
>> > 
>> > Something like this should work (in SeaBIOS's src/acpi-dsdt-isa.dsl):
>> > 
>> >     Device(PEVT) {
>> >         Name(_HID, EisaId("QEMU0001"))
>> >         OperationRegion(PEOR, SystemIO, 0x505, 0x01)
>> >         Field(PEOR, ByteAcc, NoLock, Preserve) {
>> >             PEPT,   8,
>> >         }
>> > 
>> >         Method(_STA, 0, NotSerialized) {
>> >             Store(PEPT, Local0)
>> >             If (LEqual(Local0, Zero)) {
>> >                 Return (0x00)
>> >             } Else {
>> >                 Return (0x0F)
>> >             }
>> >         }
> IIUC, here _STA reads from ioport 0x505, if the result is 0, then the
> device is not present. Otherwise, the device is present. But as Gleb
> said, ''the data you read from unassigned port is not guarantied to be
> zero, it may depend on QEMU version''. What should I do to tell if the
> device is present or not correctly?

The firmware is tied to the QEMU version, so you can rely on unassigned
ports returning zero.

Later we can change this to use fw-cfg.

Paolo

