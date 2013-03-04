Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3CDLXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:23:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197Ab3CDLW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:22:57 -0500
Date: Mon, 4 Mar 2013 13:20:23 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hu Tao <hutao@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Blue Swirl <blauwirbel@gmail.com>,
        Eric Blake <eblake@redhat.com>, Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v13 0/8] pv event interface between host and guest
Message-ID: <20130304112023.GN23616@redhat.com>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <20130303091738.GB23616@redhat.com>
 <513471F1.5020702@redhat.com>
 <20130304102131.GK23616@redhat.com>
 <51347735.9090204@redhat.com>
 <20130304104301.GL23616@redhat.com>
 <51347C23.8080802@redhat.com>
 <20130304105928.GM23616@redhat.com>
 <51348142.4070206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51348142.4070206@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 12:10:58PM +0100, Paolo Bonzini wrote:
> Il 04/03/2013 11:59, Gleb Natapov ha scritto:
> > > I want to make the ioport configurable in the device, but the PIIX and
> > > ICH9 (which are what the DSDT is written for) will always use port 0x505.
> > 
> > But the device is not part of PIIX or ICH9.
> 
> So is kvmclock, or kvmvapic.  I think it makes sense to add this device
> to PIIX or ICH9 since it is an ISA device.
> 
Those are CPU interfaces, not chipset. fw_cfg or our PIIX ACPI additions would
be better examples, but since they are always present and non configurable they
are in a different category.

> > It is additional device that
> > may or may not be present depending on a command line. So what if
> > someone configures debugcon or debugexit to use this port?
> 
> I haven't checked if debug{con,exit} will pass the _STA test, but if
> they do, the user will get a Ctrl-A or respectively an exit of QEMU when
> the guest panics.
> 
> What if someone configures debugcon on port 0x3f8?  Some guest will use
> it, some will not.
> 
Qemu should fail to start since conflict will be detected during
initialization.

> > We can always
> > blame the users, but I fill that we are making unnecessary compromises.
> 
> Once we choose an ISA device, where the user has full control of the
> address space, we already know we'll have to accept compromises.  I
> don't think this compromise is particularly bad: do discovery via ACPI
> (nice), accept that the user can trick the AML (ugly).
> 
Why would have we accept compromises, we may, but I disagree that it
is necessary? If user configures conflicting ports QEMU will detect
it during init, if configuration is correct DSDT should provide enough
information for guests to use configured devices.

--
			Gleb.
