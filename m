Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3CDLAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:00:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222Ab3CDLA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:00:29 -0500
Date: Mon, 4 Mar 2013 12:59:28 +0200
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
Message-ID: <20130304105928.GM23616@redhat.com>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <20130303091738.GB23616@redhat.com>
 <513471F1.5020702@redhat.com>
 <20130304102131.GK23616@redhat.com>
 <51347735.9090204@redhat.com>
 <20130304104301.GL23616@redhat.com>
 <51347C23.8080802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51347C23.8080802@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 11:49:07AM +0100, Paolo Bonzini wrote:
> Il 04/03/2013 11:43, Gleb Natapov ha scritto:
> > > Anyhow, this does not apply to the next submission of this series.  I
> > > think we can agree to the compromise of using ACPI but still read the
> > > port in _STA.
> > 
> > If you want to make ioport configurable I do not see how can we avoid
> > patching.
> 
> I want to make the ioport configurable in the device, but the PIIX and
> ICH9 (which are what the DSDT is written for) will always use port 0x505.
> 
But the device is not part of PIIX or ICH9. It is additional device that
may or may not be present depending on a command line. So what if
someone configures debugcon or debugexit to use this port? We can always
blame the users, but I fill that we are making unnecessary compromises.

> You can configure a different iobase for your serial ports, the guest
> can still use them but not discover them via ACPI.  This is the same thing.
> 
Probably we should patch DSDT too when it will be in QEMU :) of force
iobase to spec values if device is used as part of a chipset.

--
			Gleb.
