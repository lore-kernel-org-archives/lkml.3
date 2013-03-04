Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3CDKo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:44:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756981Ab3CDKo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:44:56 -0500
Date: Mon, 4 Mar 2013 12:43:01 +0200
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
Message-ID: <20130304104301.GL23616@redhat.com>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <20130303091738.GB23616@redhat.com>
 <513471F1.5020702@redhat.com>
 <20130304102131.GK23616@redhat.com>
 <51347735.9090204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51347735.9090204@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 11:28:05AM +0100, Paolo Bonzini wrote:
> Il 04/03/2013 11:21, Gleb Natapov ha scritto:
> >> > Just to clarify it for Hu Tao, the read from a random ioport is how the
> >> > ACPI code will detect presence of the device.
> >> > 
> > Actually no (at least in the long run, for the first version it may be
> > OK).
> 
> Agreed.
> 
> > Since we want to move DSDT generation into QEMU if device will not
> > be present QEMU will not generate corresponded Device() in DSDT, or it
> > will generate it with _STA() { Return (0x00)} hard coded.
> 
> Yes, this would be good.
> 
> > Seabios can do
> > the same if we will pass it info about device presence via fw_cfg.
> 
> True, but I don't like this a lot.  I don't like splitting decisions
> between SeaBIOS and the DSDT, you end up touching code all over the
> place and writing ASL is simpler than patching---even with all the
> machinery that we have.
That's the main argument in favor of moving DSDT into QEMU regardless
of this patch series, but as long as we have it in Seabios, have
infrastructure for patching and use it for many things already I do not
see why avoiding it.

>                          It is also simpler to move ASL from SeaBIOS to
> OVMF and/or viceversa.  I don't recall what was the opposition to a
> fw_cfg driver directly in the DSDT, but I think this would be a good
> usage for it.
> 
Basically fw_cfg was not designed with this in mind. It was really meant
to be simple interface for FW running one one CPU to use. You probably
may do locking with AML too to guaranty atomic access, but things get
complicated. Also may option that was added lately use file interface
(since this is what Kevin prefers) and manipulating strings in AML is
probably not what we want.

> Splitting it between QEMU and DSDT is a bit better, since you have to
> touch QEMU anyway to implement the feature.
> 
> Anyhow, this does not apply to the next submission of this series.  I
> think we can agree to the compromise of using ACPI but still read the
> port in _STA.
> 
If you want to make ioport configurable I do not see how can we avoid
patching.

--
			Gleb.
